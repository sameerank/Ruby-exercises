class Goal < ActiveRecord::Base
validates :title, :body, presence: true
end
