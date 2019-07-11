class Micropost < ApplicationRecord
  belongs_to :account
  has_many :favourited_by, class_name: "Favourite",
                           foreign_key: "micropost_id",
                           dependent: :destroy
  has_many :favouriters, through: :favourited_by, source: :account
  
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :account_id, presence: true
  validates :content,	 presence: true, length: { maximum: 140 }
  validate :picture_size


  private
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
