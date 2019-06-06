class Campaign < ApplicationRecord
	validates :title, presence: true,
					  length: { in: 5..30}
	validates :summary, length: { maximum: 600 }
end
