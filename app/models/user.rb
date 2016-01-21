# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  user_name  :string           not null
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  validates :user_name, presence: true

  has_many :polls,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: 'Poll'

  has_many :responses,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: 'Response'

end
