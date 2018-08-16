class Book < ActiveRecord::Base
  has_many :user_books
  has_many :users, through: :user_books
  belongs_to :category

  validates :title, presence: true
  validates :author, presence: true

  def slug
    self.title.split(/\W/).join("-").downcase
  end

  def self.find_by_slug(slug)
    self.all.find do |book|
      book.slug == slug
    end
  end
end
