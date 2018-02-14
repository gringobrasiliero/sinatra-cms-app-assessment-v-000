class UsersController < ApplicationController

  get '/users/:slug' do
      @user = User.find_by_slug(params[:slug])
      erb :'users/show'
    end

    get '/signup' do
        if logged_in?
          redirect to "/attributes/attributes.erb"
  else
        erb :'/users/create_user' , locals: {message: "Please sign up to sign in"}
    end
  end


  post '/signup' do
        if logged_in?
          redirect '/attributes/attributes.erb'
        elsif params[:username] == "" || params[:email] == "" || params[:password] == ""
      		redirect to "/signup"
        else
        		@user = User.create(params)
            @user.save
        		session[:user_id] = @user.id
            redirect '/'
      	end
    	end

get '/login' do
if logged_in?
  redirect to "/attributes/attributes.erb"
else
  erb :'/users/login'
end
end

   post '/login' do
        user = User.find_by(username: params[:username])
     if user && user.authenticate(params[:password])
        session[:user_id] = user.id
       redirect to '/attributes/attributes.erb'
     else
       redirect to '/login'
     end
   end

   get '/logout' do
     if logged_in?
       session.destroy
       redirect to '/login'
     else
       redirect to '/attributes/attributes.erb'
       end
   end


end
