class Cat < ActiveRecord::Base
  validates :color, inclusion: ['white', 'black', 'brown', 'gold', 'grey']
  validates :sex, inclusion: ['M', 'F']
  validates :name, presence: true
end
