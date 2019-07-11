class Favourite < ApplicationRecord
    belongs_to :account, class_name: "Account"
    belongs_to :micropost, class_name: "Micropost"

    validates :account_id, presence: true
    validates :micropost_id, presence: true
end
