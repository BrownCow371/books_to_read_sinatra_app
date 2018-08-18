class UsersController < ApplicationController

  get '/users' do
    if logged_in?
      redirect "users/#{current_user.id}"
    else
      erb :'users/index'
    end
  end

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
      flash[:message]="You already have an account with the email provided. Please login using the form below."
      redirect '/login'
    else
      flash[:message] = "In order to sign up, please provide you name, email and a password. Thanks!"
      redirect '/signup'
    end
  end

  get '/login' do
    if logged_in?
      redirect "users/#{current_user.id}"
    else
      erb :'users/login'
    end
  end

  post '/login' do
    @user = User.find_by(email: params[:user][:email])
    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      redirect "/users/#{@user.id}"
    else
      flash[:message] = "Unable to log you in with those credentials. Please try again."
      redirect '/login'
    end
  end



  get '/users/:id' do
    if logged_in? && current_user.id == params[:id].to_i
      @user = User.find_by(id: current_user.id)
      erb :'users/show'
    elsif logged_in? && !(current_user.id == params[:id].to_i)
      flash[:message] = "You cannot view another User's book list. We've redirected to your own book list."
      redirect "/users/#{current_user.id}"
    else
      flash[:message] = "Need to be logged in to view your book list page. Please Login."
      redirect '/login'
    end
  end

  get '/logout'do
    session.clear
    redirect '/login'
  end

end
