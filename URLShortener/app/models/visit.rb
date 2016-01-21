# == Schema Information
#
# Table name: visits
#
#  id               :integer          not null, primary key
#  shortened_url_id :integer
#  user_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class Visit < ActiveRecord::Base
  validates :shortened_url_id, presence: true
  validates :user_id, presence: true

  def self.record_visit!(user, shortened_url)
    Visit.create!(user_id: user, shortened_url_id: shortened_url)
  end

  belongs_to :user,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: 'User'

  belongs_to :shortened_url,
    foreign_key: :shortened_url_id,
    primary_key: :id,
    class_name: 'ShortenedUrl'


end
