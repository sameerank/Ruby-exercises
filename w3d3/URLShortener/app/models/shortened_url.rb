# == Schema Information
#
# Table name: shortened_urls
#
#  id           :integer          not null, primary key
#  long_url     :string
#  short_url    :string
#  submitter_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class ShortenedUrl < ActiveRecord::Base
  validates :short_url, presence: true

  def self.random_code
    while true
      possible_short_url = SecureRandom.urlsafe_base64(16)
      unless ShortenedUrl.exists?(short_url: possible_short_url)
        return possible_short_url
      end
    end
  end

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(submitter_id: user, long_url: long_url,
      short_url: self.random_code)
  end

  belongs_to :submitter,
    foreign_key: :submitter_id,
    primary_key: :id,
    class_name: 'User'

  has_many :visits,
    foreign_key: :shortened_url_id,
    primary_key: :id,
    class_name: 'Visit'

  has_many :visitors,
    through: :visits,
    source: :user

  def num_uniques
    Visit.where(shortened_url_id: id).select("user_id").distinct.count
    # Visit.where("shortened_url_id = ?", id).select("user_id").distinct.count
    # visits.select("user_id").distinct.count
  end


end
