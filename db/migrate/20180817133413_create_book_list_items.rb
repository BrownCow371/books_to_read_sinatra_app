class CreateBookListItems < ActiveRecord::Migration
  def change
    create_table :book_list_items do |t|
      t.text :note
      t.text :library_link
      t.integer :user_id
      t.integer :book_id
    end
  end
end
