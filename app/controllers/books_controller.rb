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
    if logged_in?
      @book=Book.find_by_id(params[:id])
      if @book.update(params[:book])
        redirect "/books/#{@book.id}"
      else
        flash[:message] = "When editing a book, please be sure to include both a title and an author."
        redirect "/books/#{@book.id}/edit"
      end
    else
      erb :'users/login'
    end
   end

  delete '/books/:id/delete' do
    # show usser erroe page for now - placeholder
    erb :'users/error'
  end
end
