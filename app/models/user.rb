class User < ApplicationRecord

  has_many :centers, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :listings, through: :bookings

  validates :email, presence: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :first_name, presence: true
  validates :last_name, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
