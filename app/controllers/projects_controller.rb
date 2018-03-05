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

      if params[:name] == "" #Requires a project name
        redirect to :'/projects/new'
      else #if project has name, it saves the project.
        @project = current_user.projects.create(name: params[:name], type_of_p: params[:type_of_p], description: params[:description], materials: params[:materials], link: params[:link])
        @project.save
        redirect to "/projects/#{@project.id}"
      end
    end


    get '/projects/:id' do
       if logged_in? #Requires user to be logged in to view projects
         @project = Project.find_by_id(params[:id])
         erb :'/projects/show_project'
       else #if not logged in, redirects to login page
         redirect to '/login'
       end
     end

     get '/projects/:id/edit' do
     if !logged_in? #requires user to be logged in
         redirect to '/login'
    else #only allows users that own the post be able to edit/delete it
       @project = Project.find_by_id(params[:id])
       if @project.user_id == current_user.id
         erb :'/projects/edit_project'
       else #if the post isnt their's, redirects to projects page
         redirect to "/projects"
       end
     end
   end

   patch '/projects/:id' do
     if params[:name] == "" #Makes sure user can not delete the name of the project.
       redirect to "/projects/#{params[:id]}/edit"
     else
       @project=Project.find_by_id(params[:id])
       @project.name = params[:name]
       @project.type_of_p = params[:type_of_p]
       @project.description = params[:description]
       @project.materials = params[:materials]
       @project.link = params[:link]
       @project.save
       redirect to "/projects/#{@project.id}"
     end
   end


   delete '/projects/:id/delete' do
        if logged_in?
          @project = Project.find_by_id(params[:id])
          if @project.user_id == current_user.id #makes sure the post that is trying to be deleted belongs to user
            @project.destroy
            redirect to '/projects'
        else
            redirect to '/login'
          end
        end
      end


end
