class ReviewPart < ApplicationRecord
  belongs_to :review
  belongs_to :part
end
