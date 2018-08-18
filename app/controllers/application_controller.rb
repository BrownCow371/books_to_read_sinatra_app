require './config/environment'

class ApplicationController < Sinatra::Base
  use Rack::Flash

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "allthebooksecrets"
  end

  get "/" do
    redirect '/users'
  end

  helpers do
    def logged_in?
      !!current_user
    end

    def current_user
      User.find_by_id(session[:user_id])
    end
  end

end
