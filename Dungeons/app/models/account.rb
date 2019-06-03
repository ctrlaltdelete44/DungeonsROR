class Account < ApplicationRecord
	validates :username, presence: true,
						 length: { minimum: 5 },
						 uniqueness: true
	validates :email, presence: true,
					  uniqueness: true
	validates :display_name, length: { maximum: 50 }
end
