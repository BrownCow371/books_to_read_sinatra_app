class BookListItemsController < ApplicationController
  # Users should only be able to add a book to their list once
  # (so there is only one book list item per book, per user)

  # no get '/book_list_items' index page - doesn't make any sense

  get '/book_list_items/new' do
     if logged_in?
       @categories = Category.all
       @books=Book.all.select{|book| !(current_user.books.include?(book))}
      erb :'book_list_items/new'
     else
      erb :'users/login'
     end
   end

  post '/book_list_items' do
    # binding.pry
    if params[:book_list_item][:user_id].to_i == current_user.id
      if params[:book_list_item] && params[:add_book_button]
        new_by_button = BookListItem.create(params[:book_list_item])
        redirect "/users/#{current_user.id}"
      else
        if params[:check_list_items][:book_ids]
          params[:check_list_items][:book_ids].each do |id|
            bli = BookListItem.new(book_id: id, user_id: current_user.id)
            bli.note = params[:check_list_items]["book_id_#{id}"][:note]
            bli.library_link = params[:check_list_items]["book_id_#{id}"][:library_link]
            bli.save
          end
        end

        if !params[:book][:title].empty? && Book.new(params[:book]).valid?
          book = Book.find_or_create_by(params[:book])
          new_list_item = BookListItem.new(params[:book_list_item])
          new_list_item.book_id=book.id
          new_list_item.save
        elsif !params[:book][:title].empty? || !params[:book][:author].empty? || !params[:book][:category_id].empty?
          flash[:message] = "When creating a new book, please provide both a title and an author."
          redirect '/book_list_items/new'
        end

        redirect "/users/#{current_user.id}"
      end
    else
      flash[:message]="You cannot add books to another user's list. We have redirected you to your own list."
      redirect "/users/#{current_user.id}"
    end

  end

  get '/book_list_items/:id/edit' do
     if logged_in?
      @book_list_item=BookListItem.find_by_id(params[:id])
      erb :'book_list_items/edit'
     else
      erb :'users/login'
     end
  end

  patch '/book_list_items/:id' do
    list_item = BookListItem.find_by_id(params[:id])
    if current_user.id == list_item.user_id
    # Need to edit item notes and library_link
      list_item.update(params[:book_list_item])
      flash[:message] = "You have updated your book list item for '#{list_item.book.title} by #{list_item.book.author}'."
      redirect "/users/#{current_user.id}"
    else
      flash[:message] = "You cannot update the book information for the list item you specified."
      redirect "/users/#{current_user.id}"
    end
  end

  delete '/book_list_items/:id/delete' do
   list_item = BookListItem.find_by_id(params[:id])
    if current_user.id == list_item.user_id
      flash[:message] = "You have removed '#{list_item.book.title} by #{list_item.book.author}' from your book list."
      list_item.destroy
      redirect "/users/#{current_user.id}"
    else
      flash[:message] = "You are not allowed to remove this book for the list you specified."
      redirect "/users/#{current_user.id}"
    end
  end

end
