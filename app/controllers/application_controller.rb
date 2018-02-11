require './config/environment'
require 'sinatra'

class ApplicationController < Sinatra::Base

  configure do
      set :public_folder, 'public'
      set :views, 'app/views'
  		enable :sessions
  		set :session_secret, "password_security"
    end


get '/' do
  if logged_in?
    @user = User.find(current_user.id)
    redirect to "/users/#{@user.slug}"
  else
    erb :index
  end
end


    helpers do
      def logged_in?
        !!current_user
      end

      def current_user
        User.find_by(id: session[:user_id]) if session[:user_id]
      end

    end
  end
