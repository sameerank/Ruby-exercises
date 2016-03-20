require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('q_and_a.db')

    self.results_as_hash = true
    self.type_translation = true
  end
end

class QuestionsBase
  @@table_hash = {'Question' => 'questions',
                'User' => 'users',
                'QuestionFollow' => 'questions_follows',
                'Reply' => 'replies',
                'QuestionLike' => 'question_likes'
              }

  def self.find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        "#{@@table_hash[self.to_s]}"
      WHERE
        id = ?
    SQL
    results.map { |result| self.new(result) }
  end

  def self.all
    results = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        "#{@@table_hash[self.to_s]}"
    SQL
    results.map { |result| self.new(result) }
  end

  def self.where(input)
    if input.is_a?(String)
      search_str = input
      vals = []
    else
      search_str = input.map { |k, v| "#{k} = ?"}.join(' AND ')
      vals = input.values
    end

    results = QuestionsDatabase.instance.execute(<<-SQL, *vals)
      SELECT
        *
      FROM
        #{@@table_hash[self.to_s]}
      WHERE
        #{search_str}
    SQL
    results.map { |result| self.new(result) }
  end

  def self.method_missing(method_name, *args)
    method_name = method_name.to_s
    if method_name.start_with?("find_by_")
      attributes_string = method_name[("find_by_".length)..-1]
      attribute_names = attributes_string.split("_and_")

      unless attribute_names.length == args.length
        raise "unexpected # of arguments"
      end

      search_conditions = {}
      attribute_names.each_index do |i|
        search_conditions[attribute_names[i]] = args[i]
      end
      self.where(search_conditions)
    else
      super
    end
  end

  def save
    if @id.nil?
      int_keys, int_values = [], []
      @options.each do |k, v|
        next if k == 'id'
        int_keys << k
        int_values << v
      end
      int_keys, int_values = int_keys.join(", "), int_values.join(", ")
      QuestionsDatabase.instance.execute(<<-SQL, int_keys, int_values)
        INSERT INTO
          "#{@@table_hash[self.to_s]}" (?)
        VALUES
          (?)
      SQL

      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      interpolated_stuff = @options.map { |k, v| "#{k} = #{v}" unless k == 'id' }.join(", ")
      QuestionsDatabase.instance.execute(<<-SQL, interpolated_stuff, @id)
        UPDATE
          "#{@@table_hash[self.to_s]}"
        SET
          ?
        WHERE
          id = ?
      SQL
    end
  end

end

class Question < QuestionsBase
  attr_accessor :id, :title, :body, :author_id

  def self.find_by_author_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL
    results.map { |result| Question.new(result) }
  end

  def self.find_by_title(title)
    results = QuestionsDatabase.instance.execute(<<-SQL, title)
      SELECT
        *
      FROM
        questions
      WHERE
        title = ?
    SQL
    results.map { |result| Question.new(result) }
  end

  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  def initialize(options)
    @options = options
    @id, @title, @body, @author_id = @options.values_at('id', 'title', 'body', 'author_id')
  end

  def author
    User.find_by_id(@author_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollow.followers_for_question_id(@id)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end

end

class User < QuestionsBase
  attr_accessor :id, :fname, :lname

  def self.find_by_name(fname, lname)
    results = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL
    results.map { |result| User.new(result) }
  end

  def initialize(options)
    @id, @fname, @lname = options.values_at('id', 'fname', 'lname')
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def average_karma
    QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT
        CAST(COUNT(question_likes.id) AS FLOAT) / COUNT(DISTINCT(questions.id))
      FROM
        users
      JOIN
        questions ON users.id = questions.author_id
      LEFT OUTER JOIN
        question_likes ON questions.id = question_likes.question_id
      WHERE
        users.id = ?
    SQL
  end
end

class QuestionFollow < QuestionsBase
  attr_accessor :id, :question_id, :user_id

  def self.find_by_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        user_id = ?
    SQL
    results.map { |result| QuestionFollow.new(result) }
  end

  def self.find_by_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        question_id = ?
    SQL
    results.map { |result| QuestionFollow.new(result) }
  end

  def self.followers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.id, users.fname, users.lname
      FROM
        question_follows
      JOIN
        users ON question_follows.user_id = users.id
      WHERE
        question_follows.question_id = ?
    SQL
    results.map { |result| User.new(result) }
  end

  def self.followed_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.id, questions.title, questions.body, questions.author_id
      FROM
        question_follows
      JOIN
        questions ON question_follows.question_id = questions.id
      WHERE
        question_follows.user_id = ?
    SQL
    results.map { |result| Question.new(result) }
  end

    def self.most_followed_questions(n)
      results = QuestionsDatabase.instance.execute(<<-SQL, n)
        SELECT
          questions.*
        FROM
          questions
        JOIN
          question_follows ON questions.id = question_follows.question_id
        GROUP BY
          question_id
        ORDER BY
          COUNT(*) DESC
        LIMIT ?
      SQL
      results.map { |result| Question.new(result) }
    end

  def initialize(options)
    @id, @user_id, @question_id = options.values_at('id', 'user_id', 'question_id')
  end
end

class Reply < QuestionsBase
  attr_accessor :id, :question_id, :parent_id, :user_id, :body

  def self.find_by_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL
    results.map { |result| Reply.new(result) }
  end

  def self.find_by_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL
    results.map { |result| Reply.new(result) }
  end

  def self.find_by_parent_id(parent_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, parent_id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = ?
    SQL
    results.map { |result| Reply.new(result) }
  end

  def initialize(options)
    @id, @question_id, @parent_id, @user_id, @body =
      options.values_at('id', 'question_id', 'parent_id', 'user_id', 'body')
  end

  def author
    User.find_by_id(@user_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    Reply.find_by_parent_id(@parent_id)
  end

  def child_replies
    results = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = ?
    SQL
    results.map { |result| Reply.new(result) }
  end

end

class QuestionLike < QuestionsBase
  attr_accessor :id, :question_id, :user_id

  def self.find_by_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        user_id = ?
    SQL
    results.map { |result| QuestionLike.new(result) }
  end

  def self.find_by_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        question_id = ?
    SQL
    results.map { |result| QuestionLike.new(result) }
  end

  def self.likers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        users
      JOIN
        question_likes ON users.id = question_likes.user_id
      WHERE
        question_likes.question_id = ?
    SQL
    results.map { |result| User.new(result) }
  end

  def self.num_likes_for_question_id(question_id)
    QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(*) AS num_likes
      FROM
        question_likes
      WHERE
        question_id = ?
    SQL
  end

  def self.liked_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        question_likes
      JOIN
        questions ON question_likes.question_id = questions.id
      WHERE
        user_id = ?
    SQL
    results.map { |result| Question.new(result) }
  end

  def self.most_liked_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_likes ON questions.id = question_likes.question_id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(*) DESC
      LIMIT ?
    SQL
    results.map { |result| Question.new(result) }
  end

  def initialize(options)
    @id, @question_id, @user_id = options.values_at('id', 'question_id', 'user_id')
  end
end
