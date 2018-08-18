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
      @categories = Category.all
      erb :'categories/index'
    else
      redirect '/login'
    end
  end

  post '/categories' do

  end

  get '/categories/:id' do
    if logged_in?
      @category = Category.find_by_id(params[:id])
      erb :'categories/show'
    else
      redirect '/logged_in'
    end
  end
end
