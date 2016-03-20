# == Schema Information
#
# Table name: polls
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  user_id    :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class Poll < ActiveRecord::Base
  validates :title, presence: true
  validates :user_id, presence: true

  belongs_to :user,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: 'User'

  has_many :questions,
    foreign_key: :poll_id,
    primary_key: :id,
    class_name: 'Question'

end
