class User < ActiveRecord::Base
  has_many :book_list_items
  has_many :books, through: :book_list_items
  has_many :categories, through: :books

  has_secure_password

  validates :name, presence: true
  validates :email, presence: true
  validates :password, presence: true

  def slug
    self.name.split(/\W/).join("-").downcase
  end

  def self.find_by_slug(slug)
    self.all.find do |user|
      user.slug == slug
    end
  end
end
