class Listing < ApplicationRecord
  belongs_to :center
  has_many :bookings, dependent: :destroy

  validates :category, presence: true
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than: 0.00 }
  validates :date, presence: true
  validates :start_time, presence: true
  validates :duration, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :dive_count, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :max_divers, presence: true, numericality: { only_integer: true, greater_than: 0 }

  scope :by_trips, -> { where("category = ?", "trip") }
  scope :by_courses, -> { where("category = ?", "course") }
  scope :by_location, ->(location) { Listing.joins(:center).where("location ILIKE ?", "%#{location}%") }
end
