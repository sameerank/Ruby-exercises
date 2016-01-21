# == Schema Information
#
# Table name: responses
#
#  id               :integer          not null, primary key
#  answer_choice_id :integer          not null
#  user_id          :integer          not null
#  created_at       :datetime
#  updated_at       :datetime
#

class Response < ActiveRecord::Base
  validates :answer_choice_id, presence: true
  validates :user_id, presence: true
  validates_uniqueness_of :user_id, scope: :answer_choice_id
  validate :not_duplicate_response

  belongs_to :answer_choice,
    foreign_key: :answer_choice_id,
    primary_key: :id,
    class_name: 'AnswerChoice'

  belongs_to :user,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: 'User'

  def not_duplicate_response

    # Response.joins("JOIN answer_choices
    # ON responses.answer_choice_id = answer_choices.id
    # JOIN questions ON questions.id = answer_choices.question_id")
    siblings = sibling_responses.map { |el| el.id }

    Response.includes(:user_id).where('answer_choice_id IN ?', siblings)


  end

  def sibling_responses
    Response.find_by_sql(<<-SQL)
      SELECT id
      FROM answer_choices
      WHERE question_id = (
        SELECT question_id
        FROM answer_choices
        WHERE id = :answer_choice_id)
    SQL
  end

end
