class Profile < ApplicationRecord
  belongs_to :user
  has_many :listings_to_sell, class_name: "Listing", foreign_key: "seller_id"
  has_many :listings_to_buy, class_name: "Listing", foreign_key: "buyer_id"

  has_many :reviews_to_make, class_name: "Listing", foreign_key: "buyer_id"
  has_many :reviews_to_receive, class_name: "Listing", foreign_key: "seller_id"
  
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :user_name, presence: true, uniqueness: true 
  
end
