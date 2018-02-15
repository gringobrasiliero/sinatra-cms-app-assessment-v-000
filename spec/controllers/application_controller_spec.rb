require 'spec_helper'

describe ApplicationController do

  describe "Homepage" do
    it 'loads the homepage' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome")
    end
  end

  describe "Signup Page" do

    it 'loads the signup page' do
      get '/signup'
      expect(last_response.status).to eq(200)
    end

    it 'signup directs user to index' do
      params = {
        :username => "skittles123",
        :email => "skittles@aol.com",
        :password => "rainbows"
      }
      post '/signup', params
      expect(last_response.location).to include("/projects")
    end

    it 'does not let a user sign up without a username' do
      params = {
        :username => "",
        :email => "skittles@aol.com",
        :password => "rainbows"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without an email' do
      params = {
        :username => "skittles123",
        :email => "",
        :password => "rainbows"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without a password' do
      params = {
        :username => "skittles123",
        :email => "skittles@aol.com",
        :password => ""
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a logged in user view the signup page' do
      user = User.create(:username => "skittles123", :email => "skittles@aol.com", :password => "rainbows")
      params = {
        :username => "skittles123",
        :email => "skittles@aol.com",
        :password => "rainbows"
      }
      post '/signup', params
      session = {}
      session[:user_id] = user.id
      get '/signup'
      expect(last_response.location).to include('/projects')
    end
  end

  describe "login" do
    it 'loads the login page' do
      get '/login'
      expect(last_response.status).to eq(200)
    end

    it 'loads the projects index after login' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome,")
    end

    it 'does not let user view login page if already logged in' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      session = {}
      session[:user_id] = user.id
      get '/login'
      expect(last_response.location).to include("/projects")
    end
  end

  describe "logout" do
    it "lets a user logout if they are already logged in" do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      get '/logout'
      expect(last_response.location).to include("/login")
    end

    it 'does not let a user logout if not logged in' do
      get '/logout'
      expect(last_response.location).to include("/")
    end

    it 'does not load /projects if user not logged in' do
      get '/projects'
      expect(last_response.location).to include("/login")
    end

    it 'does load /projects if user is logged in' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")


      visit '/login'

      fill_in(:username, :with => "becky567")
      fill_in(:password, :with => "kittens")
      click_button 'submit'
      expect(page.current_path).to eq('/projects')
    end
  end

  describe 'user show page' do
    it 'shows all a single users projects' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
      project1 = Project.create(:name => "projecting!", :user_id => user.id)
      project2 = Project.create(:name => "project project project", :user_id => user.id)
      get "/users/#{user.slug}"

      expect(last_response.body).to include("projecting!")
      expect(last_response.body).to include("project project project")

    end
  end

  describe 'index action' do
    context 'logged in' do
      it 'lets a user view the projects index if logged in' do
        user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        project1 = Project.create(:name => "Projecting!", :user_id => user1.id)

        user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
        project2 = Project.create(:name => "look at this project", :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "/projects"
        expect(page.body).to include(project1.name)
        expect(page.body).to include(project2.name)
      end
    end

    context 'logged out' do
      it 'does not let a user view the projects index if not logged in' do
        get '/projects'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'new action' do
    context 'logged in' do
      it 'lets user view new project form if logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/projects/new'
        expect(page.status_code).to eq(200)
      end

      it 'lets user create a project if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/projects/new'
        fill_in(:name, :with => "project!!!")
        click_button 'submit'

        user = User.find_by(:username => "becky567")
        project = Project.find_by(:name => "project!!!")
        expect(project).to be_instance_of(Project)
        expect(project.user_id).to eq(user.id)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user project from another user' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/projects/new'

        fill_in(:name, :with => "project!!!")
        click_button 'submit'

        user = User.find_by(:id=> user.id)
        user2 = User.find_by(:id => user2.id)
        project = Project.find_by(:name => "Project!!!")
        expect(project).to be_instance_of(Project)
        expect(project.user_id).to eq(user.id)
        expect(project.user_id).not_to eq(user2.id)
      end

      it 'does not let a user create a blank project' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/projects/new'

        fill_in(:name, :with => "")
        click_button 'submit'

        expect(Project.find_by(:name => "")).to eq(nil)
        expect(page.current_path).to eq("/projects/new")
      end
    end

    context 'logged out' do
      it 'does not let user view new project form if not logged in' do
        get '/projects/new'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'show action' do
    context 'logged in' do
      it 'displays a single project' do

        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        project = Project.create(:name => "i am a boss at projecting", :user_id => user.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit "/projects/#{project.id}"
        expect(page.status_code).to eq(200)
        expect(page.body).to include("Delete project")
        expect(page.body).to include(project.name)
        expect(page.body).to include("Edit project")
      end
    end

    context 'logged out' do
      it 'does not let a user view a project' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        project = Project.create(:name => "i am a boss at projecting", :user_id => user.id)
        get "/projects/#{project.id}"
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'edit action' do
    context "logged in" do
      it 'lets a user view project edit form if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        project = Project.create(:name => "projecting!", :user_id => user.id)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/projects/1/edit'
        expect(page.status_code).to eq(200)
        expect(page.body).to include(project.name)
      end

      it 'does not let a user edit a project they did not create' do
        user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        project1 = Project.create(:name => "projecting!", :user_id => user1.id)

        user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
        project2 = Project.create(:name => "look at this project", :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        session = {}
        session[:user_id] = user1.id
        visit "/projects/#{project2.id}/edit"
        expect(page.current_path).to include('/projects')
      end

      it 'lets a user edit their own project if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        project = Project.create(:name => "projecting!", :user_id => 1)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/projects/1/edit'

        fill_in(:name, :with => "i love projecting")

        click_button 'submit'
        expect(Project.find_by(:name => "i love Projecting")).to be_instance_of(Project)
        expect(Project.find_by(:name => "projecting!")).to eq(nil)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user edit a text with blank name' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        project = Project.create(:name => "projecting!", :user_id => 1)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/projects/1/edit'

        fill_in(:name, :with => "")

        click_button 'submit'
        expect(Project.find_by(:name => "i love projecting")).to be(nil)
        expect(page.current_path).to eq("/projects/1/edit")
      end
    end

    context "logged out" do
      it 'does not load let user view project edit form if not logged in' do
        get '/projects/1/edit'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'delete action' do
    context "logged in" do
      it 'lets a user delete their own project if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        project = Project.create(:name => "projecting!", :user_id => 1)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit 'projects/1'
        click_button "Delete project"
        expect(page.status_code).to eq(200)
        expect(Project.find_by(:name => "projecting!")).to eq(nil)
      end

      it 'does not let a user delete a project they did not create' do
        user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        project1 = Project.create(:name => "projecting!", :user_id => user1.id)

        user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
        project2 = Project.create(:name => "look at this project", :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "projects/#{project2.id}"
        click_button "Delete project"
        expect(page.status_code).to eq(200)
        expect(Project.find_by(:name => "look at this project")).to be_instance_of(Project)
        expect(page.current_path).to include('/projects')
      end
    end

    context "logged out" do
      it 'does not load let user delete a project if not logged in' do
        project = Project.create(:name => "projecting!", :user_id => 1)
        visit '/projects/1'
        expect(page.current_path).to eq("/login")
      end
    end
  end
end
