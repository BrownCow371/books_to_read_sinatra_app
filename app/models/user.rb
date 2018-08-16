class User < ActiveRecord::Base
  has_many :books
  has_many :categories, through: :books

  has_secure_password

  validates :name, presence: true
  validates :email, presence: true
  validates :password, presence: true
end
