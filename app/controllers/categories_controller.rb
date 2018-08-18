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

    @cat = Category.find_or_initialize_by(name: params[:category][:name])
      # binding.pry
    if @cat.valid? && params[:category][:book_ids]
      @cat.save
      params[:category][:book_ids].each do |book_id|
        book=Book.find_by_id(book_id)
        book.category= @cat
        book.save
      end
      redirect "/categories/#{@cat.id}"
    elsif !@cat.valid?
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
    # binding.pry
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
      redirect "/categories/#{@category.id}"
    elsif params[:category][:name].empty?
      flash[:message] = "When editing a category, please be sure to provide a category name."
      redirect "/categories/#{@category.id}/edit"
    else
      redirect '/login'
    end
  end


end
