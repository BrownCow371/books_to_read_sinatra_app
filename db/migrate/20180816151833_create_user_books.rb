class CreateUserBooks < ActiveRecord::Migration
  def change
    create_table :user_books do |t|
      t.text :note
      t.text :library_link
      t.integer :user_id
      t.integer :book_id
    end
  end
end
