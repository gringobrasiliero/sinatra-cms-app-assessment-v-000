require 'rack-flash'
class UsersController < ApplicationController
use Rack::Flash

  get '/users/:slug' do
      @user = User.find_by_slug(params[:slug])
      @projects = Project.all
      erb :'users/show'
    end

    get '/signup' do
      @owner = "Nolan"
        if logged_in?
          redirect to "/projects"
  else
        erb :'/users/create_user'
    end
  end


  post '/signup' do
        if logged_in?
          redirect to '/projects'
        elsif params[:username].empty? || params[:email].empty? || params[:password].empty?
flash[:message] = "You need to have a username, email, and password. Try again."
          redirect to '/signup'

        else
        		@user = User.create(params)
        		session[:user_id] = @user.id
            redirect to '/projects'
      	end
    	end

get '/login' do
if logged_in?
  redirect to "/projects"
else
  erb :'/users/login'
end
end

   post '/login' do
        user = User.find_by(username: params[:username])
     if user && user.authenticate(params[:password])
        session[:user_id] = user.id
       redirect to 'projects'
     else
       redirect to '/login'
     end
   end

   get '/logout' do
     if logged_in?
       session.destroy
       redirect to '/login'
         end
   end


end
