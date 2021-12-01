class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :listing
  has_one :center, through: :listing

  validates :no_of_divers, presence: true, numericality: { only_integer: true, greater_than: 0.00 }
  validates :status, presence: true
  validates :costs, presence: true
end
