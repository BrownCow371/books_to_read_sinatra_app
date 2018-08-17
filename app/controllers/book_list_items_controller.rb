class BookListItemsController < ApplicationController

  get '/book_list_items/new' do
     if logged_in?
      @books=Book.all.select{|book| !(current_user.books.include?(book))}
      erb :'book_list_items/new'
     else
      erb :'users/login'
     end
  end

  post '/book_list_items' do
    
  end


  delete '/book_list_items/:id/delete' do
   #  this does not delete books. This removes the link between a user and a book -
   #  ie. this removes the book from the user's book list
   list_item = BookListItem.find_by_id(params[:id])
    if current_user.id == list_item.id
      flash[:message] = "We have removed #{list_item.book.title} by #{list_item.book.author} from your book list."
      list_item.destroy
      redirect "/users/#{current_user.id}"
    else
      flash[:message] = "You are not allowed to remove this book for the list you specified."
      redirect "/users/#{current_user.id}"
    end
  end
end
