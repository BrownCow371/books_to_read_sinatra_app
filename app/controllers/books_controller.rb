class BooksController < ApplicationController


 get '/books' do
   if logged_in?
     @books=Book.all
     erb :'books/index'
   else
     erb :'users/login'
   end
 end

# no get '/books/new or post '/books'
# new books are handled through book_list_items_controller

  get '/books/:id' do
     if logged_in?
       @book=Book.find_by_id(params[:id])
       erb :'books/show'
     else
       erb :'users/login'
     end
  end

    get '/books/:id/edit' do
      if logged_in?
        @categories = Category.all
        @book=Book.find_by_id(params[:id])
        erb :'books/edit'
      else
        erb :'users/login'
      end
    end

   patch '/books/:id' do
      @book = Book.find_by_id(params[:id])
      @dup = Book.find_by(title: params[:book][:title], author: params[:book][:author])
      if !logged_in?
        erb :'users/login'
      elsif @dup && @book.id != @dup.id
          flash[:message] = "There is already a book in the system with the same title and authur. Redirected to that book show page."
          redirect "/books/#{@dup.id}"
      elsif @book.update(params[:book])
        # if the book params provide are valid, the book is updated and user is redirected to
        # the book show page with an succeffully updated message
        flash[:message] = "You have successfully updated the '#{@book.title}' book."
        redirect "/books/#{@book.id}"
      else
        flash[:message] = "When editing a book, please be sure to include both a title and an author."
        redirect "/books/#{@book.id}/edit"
      end
   end

  delete '/books/:id/delete' do
    @book = Book.find_by_id(params[:id])
    if (@book.book_list_items.count == 1 && user_authorized?(@book.book_list_items.first.user_id))
      flash[:message] = "You have removed '#{@book.title} by #{@book.author}' from the book index."
      @book.destroy
      redirect "/books"
    else
      flash[:message] = "You are not allowed to remove this book - it has been added to another user's book list."
      redirect "/books/#{@book.id}"
    end
  end
end
