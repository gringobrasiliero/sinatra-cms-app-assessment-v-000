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
        @project = current_user.projects.create(name: params[:name], type_of_p: params[:type_of_p], description: params[:description], materials: params[:materials], link: params[:link])
        #@project.save
        redirect to "/projects/#{@project.id}"
      end
    end


    get '/projects/:id' do
       if logged_in?
         @project = Project.find_by_id(params[:id])
         erb :'/projects/show_project'
       else
         redirect to '/login'
       end
     end

     get '/projects/:id/edit' do
     if !logged_in?
         redirect to '/login'
    else
       @project = Project.find_by_id(params[:id])
       if @project.user_id == current_user.id
         erb :'/projects/edit_project'
       else
         redirect to "/projects"
       end
     end
   end

   patch '/projects/:id' do
     if params[:name] == ""
       redirect to "/projects/#{params[:id]}/edit"
     else
       @project=Project.find_by_id(params[:id])
       @project.name = params[:name]
       @project.save
       redirect to "/projects/#{@project.id}"
     end
   end

   delete '/projects/:id/delete' do
        if logged_in?
          @project = Project.find_by_id(params[:id])
          if @project.user_id == current_user.id
            @project.destroy
            redirect to '/projects'
        else
            redirect to '/login'
          end
        end
      end


end
