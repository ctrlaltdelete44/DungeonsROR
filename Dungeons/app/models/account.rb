class Account < ApplicationRecord
    before_save {  email.downcase!  }
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
end
