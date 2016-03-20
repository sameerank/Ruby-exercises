# == Schema Information
#
# Table name: questions
#
#  id            :integer          not null, primary key
#  poll_id       :integer          not null
#  question_text :text             not null
#  created_at    :datetime
#  updated_at    :datetime
#

class Question < ActiveRecord::Base
  validates :question_text, presence: true
  validates :poll_id, presence: true

  belongs_to :poll,
    foreign_key: :poll_id,
    primary_key: :id,
    class_name: 'Poll'

  has_many :answer_choices,
    foreign_key: :question_id,
    primary_key: :id,
    class_name: 'AnswerChoice'

end
