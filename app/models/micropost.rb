# frozen_string_literal: true

class Micropost < ApplicationRecord
  belongs_to :account
  has_many :favourited_by, class_name: 'Favourite',
                           foreign_key: 'micropost_id',
                           dependent: :destroy
  has_many :favouriters, through: :favourited_by, source: :account

  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  has_one_attached :picture_new
  validates :account_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size, if: -> (m) { m.picture_new.attached? }

  private

  def picture_size
    errors.add(:picture_new, 'should be less than 5MB') if picture_new.blob.byte_size > (5*1024*1024)
  end
end
