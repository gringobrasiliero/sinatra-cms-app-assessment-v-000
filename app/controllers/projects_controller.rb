class ProjectsController < ApplicationController


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


end
