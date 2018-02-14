class ProjectsController < ApplicationController

  get '/projects' do
     if logged_in?
       @user = current_user
       @projects = Project.all
       erb :'/projects/projects'
     else
       redirect to '/login'
     end
   end

  get '/projects/new' do
    if logged_in?
      erb :'/projects/create_project'
    else
      redirect to '/login'
    end
  end

  post '/projects' do
      if params[:name] == ""
        redirect to :'/projects/new'
      else
        @project = Project.create(params)
        @project.save
        redirect to "/projects/#{@project.id}"
      end
    end

    get '/projects/:id' do
       if logged_in?
         @project = Project.find_by_id(params[:id])
         erb :'projects/show_project'
       else
         redirect to '/login'
       end
     end

end
