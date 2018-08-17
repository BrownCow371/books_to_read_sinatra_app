class Book < ActiveRecord::Base
  has_many :book_list_items
  has_many :users, through: :book_list_items
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
