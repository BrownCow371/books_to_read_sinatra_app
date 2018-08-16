class Category < ActiveRecord::Base
  has_many :books
  has_many :users, through: :books

  validates :name, presence: true
end
