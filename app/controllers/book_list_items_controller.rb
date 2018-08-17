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
    # binding.pry
    if params[:user_id].to_i == current_user.id
      params[:book_list_item][:book_ids].each do |id|
        bli = BookListItem.new(book_id: id, user_id: current_user.id)
        bli.note = params[:book_list_item]["book_id_#{id}"][:note]
        bli.library_link = params[:book_list_item]["book_id_#{id}"][:library_link]
        bli.save
        # binding.pry
      end
      redirect "/users/#{current_user.id}"
    else
      flash[:message]="You cannot add books to another user's list. We have redirected you to your own list."
      redirect "/users/#{current_user.id}"
    end
  end


  delete '/book_list_items/:id/delete' do
   #  this does not delete books. This removes the link between a user and a book -
   #  ie. this removes the book from the user's book list
   list_item = BookListItem.find_by_id(params[:id])
    if current_user.id == list_item.user_id
      flash[:message] = "We have removed #{list_item.book.title} by #{list_item.book.author} from your book list."
      list_item.destroy
      redirect "/users/#{current_user.id}"
    else
      flash[:message] = "You are not allowed to remove this book for the list you specified."
      redirect "/users/#{current_user.id}"
    end
  end
end
