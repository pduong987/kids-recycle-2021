class Review < ApplicationRecord
  belongs_to :profile
  belong_to :buyer, class_name: "Profile", optional: true
  belong_to :seller, class_name: "Profile"
end
