# frozen_string_literal: true

class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :microposts, dependent: :destroy
  has_many :favourite_posts, class_name: 'Favourite',
                             foreign_key: 'account_id',
                             dependent: :destroy
  has_many :favourites, through: :favourite_posts, source: :micropost

  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  validates(:display_name, length: { maximum: 100 })

  validates(:email, length: { maximum: 255 })

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
    following_ids.include?(other_account.id)
  end

  def favourite(micropost)
    favourites << micropost
  end

  def unfavourite(micropost)
    favourites.delete(micropost)
  end

  def favourited?(micropost)
    favourite_ids.include?(micropost.id)
  end
end
