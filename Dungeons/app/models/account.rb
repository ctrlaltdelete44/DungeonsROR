class Account < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :favourites, class_name: "Micropost"

  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  before_save :downcase_email
	before_create :create_activation_digest
    attr_accessor :remember_token, :activation_token, :reset_token

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

	 def create_reset_digest
		self.reset_token = Account.new_token
		update_columns(reset_digest: Account.digest(reset_token), reset_sent_at: Time.zone.now)
	 end

	 def send_password_reset_email
		AccountMailer.password_reset(self).deliver_now
	 end

	 def password_reset_expired?
		reset_sent_at < 2.hours.ago
	 end

  def feed
    following_ids_sql = "SELECT followed_id FROM relationships
                     WHERE follower_id = :account_id"
    Micropost.where("account_id IN (#{following_ids_sql})
                     OR account_id = :account_id", account_id: id)
  end
  
  def follow(other_account)
    following << other_account
  end

  def unfollow(other_account)
    following.delete(other_account)
  end

  def following?(other_account)
    following.include?(other_account)
  end

  def favourite(micropost)
    favourites << micropost
  end

  def unfavourite(micropost)
    favourites.delete(micropost)
  end

  def favourited?(micropost)
    favourites.include?(micropost)
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
