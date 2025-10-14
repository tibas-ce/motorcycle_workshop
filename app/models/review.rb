class Review < ApplicationRecord
  belongs_to :scheduling
  belongs_to :motorcycle
  belongs_to :mechanic
end
