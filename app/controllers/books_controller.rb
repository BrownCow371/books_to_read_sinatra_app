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
      @book=Book.find_by_id(params[:id])
      erb :'books/edit'
    else
      erb :'users/login'
    end
   end

  delete '/books/:id' do
    # show usser erroe page for now - placeholder
    erb :'users/error'
  end
end
