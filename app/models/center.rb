class Center < ApplicationRecord
  belongs_to :user
  has_many :listings, dependent: :destroy
  has_many :bookings, through: :listings

  validates :name, presence: true
  validates :description, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true
  validates :email, presence: true
  validates :location, presence: true
end
