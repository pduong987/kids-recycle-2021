class Listing < ApplicationRecord
  # belongs_to :profile
  belongs_to :buyer, class_name: "Profile", optional: true
  belongs_to :seller, class_name: "Profile"
  has_many_attached :pictures

  # Add Validations

  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: -1}
  validates :status, presence: true
  validates :location, presence: true
end
