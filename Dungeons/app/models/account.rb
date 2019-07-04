class Account < ApplicationRecord
    before_save :downcase_email
	before_create :create_activation_digest
    attr_accessor :remember_token, :activation_token

    validates( :display_name, length: { maximum: 100 })

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

    validates( :email, presence: true,
                       length: { maximum: 255 },
                       format: { with: VALID_EMAIL_REGEX },
                       uniqueness: { case_sensitive: false })

      has_secure_password
      validates :password, presence: true, length: { minimum: 8 }, allow_nil: true

      #returns hash digest of a string
      def Account.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                                                                        BCrypt::Engine.cost
         BCrypt::Password.create(string, cost: cost)
      end

      #generates token for remembering user
      def Account.new_token
        SecureRandom.urlsafe_base64
      end

      def remember
        self.remember_token = Account.new_token
        update_attribute(:remember_digest, Account.digest(remember_token))
      end

      def authenticated?(attribute, token)
	  digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
     end

     def forget
        update_attribute(:remember_digest, nil)
     end

	 def activate
		update_columns(activated: true, activated_at: Time.zone.now)
	 end

	 def send_activation_email
		AccountMailer.account_activation(self).deliver_now
	 end

	 private
		def downcase_email
			self.email = email.downcase
		end
		
		def create_activation_digest
			self.activation_token = Account.new_token
			self.activation_digest = Account.digest(activation_token)
		end
end
