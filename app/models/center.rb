class Center < ApplicationRecord
  belongs_to :user
  has_many :listings, dependent: :destroy
  has_many :bookings, through: :listings
  has_one_attached :photo
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  validates :name, presence: true
  validates :description, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true
  validates :email, presence: true
  validates :location, presence: true

  scope :by_location, ->(location) { where("location ILIKE ?", "%#{location}%") }
end
