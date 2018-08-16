class UsersController < ApplicationController

  get '/signup' do
    if logged_in?
      redirect "/users/#{current_user.id}"
    else
      erb :'users/new_user'
    end
  end

  post '/signup' do
    @user =User.new(params[:user])
    if @user.valid? && !User.find_by(email: params[:user][:email])
      @user.save
      session[:user_id] = @user.id
      redirect "users/#{@user.id}"
    elsif User.find_by(email: params[:user][:email])
      flash[:message]="You already have an account with the email provided. Please use the Login form below."
      redirect '/login'
    else
      flash[:message] = "In order to sign up, please provide you name, email and a password. Thanks!"
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
