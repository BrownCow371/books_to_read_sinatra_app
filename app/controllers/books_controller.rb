class BooksController < ApplicationController

 # Users should only be able to add a book to their list once
 # users should only be able to add one book list itme per book (so only one set of notes/book location per book)

 get '/books' do
   if logged_in?
     @books=Book.all
     erb :'books/index'
   else
     erb :'users/login'
   end
 end

 get '/books/add_book' do
    if logged_in?
     @books=Book.all
     erb :'books/add_book'
    else
     erb :'users/login'
    end
 end

 delete '/books/:id/delete' do
  #  binding.pry
  #  @user = current_user
  #  @book = Book.find_by_id(params[:id])
   current_user.book_list_items.find_by(book_id: params[:id]).destroy
   redirect "/users/#{current_user.id}"
 end
end
