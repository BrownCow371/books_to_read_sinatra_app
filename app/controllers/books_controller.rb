class BooksController < ApplicationController

 # Users should only be able to add a book to their list once
 # users should only be able to add one book list itme per book (so only one set of notes/book location per book)

 get '/books' do
   @books=Book.all
   erb :'books/index'
 end
end
