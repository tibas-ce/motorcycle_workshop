class Motorcycle < ApplicationRecord
  belongs_to :user
  belongs_to :motorcycle_model
end
