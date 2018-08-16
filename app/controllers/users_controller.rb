class UsersController < ApplicationController

  get '/signup' do
    if logged_in?
      redirect "/users/#{current_user.id}"
    else
      erb :'users/new_user'
    end
  end

  post '/signup' do
    @user = User.new(params[:user])
    if @user.valid?
      @user.save
      session[:user_id] = @user.id
      redirect "users/#{@user.id}"
    else
      flash[:message] = "Please provide a Name, Email and Password in order to Sign up. Thanks!"
      redirect '/signup'
    end
  end

  get '/login' do

  end

  post '/login' do

  end

  get '/users/:id' do
    if logged_in?
      @user = User.find_by_id(params[:id])
    else
      flash[:message] = "Need to be logged in to view your book list page. Please Login."
      redirect '/login'
    end

  end

end
