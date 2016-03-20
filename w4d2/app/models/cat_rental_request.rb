# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :integer          not null, primary key
#  cat_id     :integer          not null
#  start_date :date             not null
#  end_date   :date
#  status     :string           default("PENDING")
#  created_at :datetime
#  updated_at :datetime
#

class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, presence: true
  validates :status, inclusion: ["PENDING", "APPROVED", "DENIED"]
  validate :overlapping_requests

  belongs_to :cat

  def overlapping_requests
    my_start_date = self.start_date
    my_end_date = self.end_date
    CatRentalRequest.where("id != #{self.id} AND cat_id = #{self.cat_id} AND (
      (start_date < #{my_start_date} AND end_date > #{my_start_date}) OR
      (start_date > #{my_end_date} AND end_date > #{my_end_date}) OR
      (start_date > #{my_start_date} AND end_date < #{my_end_date}) OR
      (start_date < #{my_start_date} AND end_date > #{my_end_date})
      )")
  end

  def overlapping_approved_requests
    unless overlapping_requests.empty?
      error[:cat_rental_requests] << "The request is overlapping."
    end
  end
end
