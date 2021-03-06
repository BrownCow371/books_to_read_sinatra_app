class CategoriesController < ApplicationController

  get '/categories' do
    if logged_in?
      @categories = Category.all
      erb :'categories/index'
    else
      redirect '/login'
    end
  end

  get '/categories/new' do
    if logged_in?
      @book_wo_cat=Book.all.select{|b| b.category_id == nil}
      erb :'categories/new'
    else
      redirect '/login'
    end
  end

  post '/categories' do
    @category = Category.find_or_initialize_by(name: params[:category][:name])
    if @category.valid?
      @category.save
      if params[:category][:book_ids]
        params[:category][:book_ids].each do |book_id|
          book=Book.find_by_id(book_id)
          book.category= @category
          book.save
          end
        end
      flash[:message] = "You have successfully added the '#{@category.name}' category."
      redirect "/categories/#{@category.id}"
    elsif !@category.valid?
      flash[:message] = "When creating a category, please be sure to provide a category name."
      redirect "/categories/new"
    else
      flash[:message] = "Something went wrong?"
      redirect "/categories"
    end
  end

  get '/categories/:id' do
    if logged_in?
      @category = Category.find_by_id(params[:id])
      erb :'categories/show'
    else
      redirect '/login'
    end
  end

  get '/categories/:id/edit' do
    if logged_in?
      @book_wo_cat=Book.all.select{|b| b.category_id == nil}
      @category = Category.find_by_id(params[:id])
      erb :'categories/edit'
    else
      redirect '/login'
    end
  end

  patch '/categories/:id' do
    @category = Category.find_by_id(params[:id])
    if logged_in? && !params[:category][:name].empty?
      @category.update(name: params[:category][:name])
        if params[:category][:book_ids]
          params[:category][:book_ids].each do |book_id|
            book=Book.find_by_id(book_id)
            book.category= @category
            book.save
          end
        end
      flash[:message] = "You have successfully updated the '#{@category.name}' category."
      redirect "/categories/#{@category.id}"
    elsif params[:category][:name].empty?
      flash[:message] = "When editing a category, please be sure to provide a category name."
      redirect "/categories/#{@category.id}/edit"
    else
      redirect '/login'
    end
  end

  delete '/categories/:id/delete' do
    @category= Category.find_by_id(params[:id])
    if @category.books.empty?
      flash[:message] = "You have removed '#{@category.name}' from the list of available categories."
      @category.destroy
      redirect "/categories"
    else
      flash[:message] = "You are not allowed to remove this category - it is associated with at least one book."
      redirect "/categories/#{@category.id}"
    end
  end

end
