class Account < ApplicationRecord
	before_save { self.email = email.downcase }

	validates :username, presence: true,
						 length: { minimum: 5 },
						 uniqueness: true

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true,
					  uniqueness: true,
					  format: { with: VALID_EMAIL_REGEX }
	validates :display_name, length: { maximum: 50 }
end
