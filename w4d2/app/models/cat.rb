# == Schema Information
#
# Table name: cats
#
#  id          :integer          not null, primary key
#  birth_date  :date
#  color       :string
#  name        :string           not null
#  sex         :string(1)
#  description :text
#

class Cat < ActiveRecord::Base
  COLORS = ['white', 'black', 'brown', 'gold', 'grey']
  
  validates :color, inclusion: COLORS
  validates :sex, inclusion: ['M', 'F']
  validates :name, presence: true

  has_many :cat_rental_requests
end
