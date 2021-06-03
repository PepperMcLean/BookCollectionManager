class UsersController < ApplicationController
    get '/signup' do 
        erb :'/users/new'
    end

    post "/signup" do
		if not !!User.find_by(:username => params[:username])
			user = User.new(:username => params[:username], :password => params[:password])
			if user.save
				redirect "/login"
			else
				redirect "/failure"
			end
		else
			redirect "/taken"
		end
	end

	get "/taken" do
		erb :'/users/taken'
	end

    get "/login" do
        erb :'/users/index'
    end

    post "/login" do
		user = User.find_by(:username => params[:username])
		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			redirect "/home"
		else
			redirect "/failure"
		end
	end

    get "/failure" do
		erb :'/users/failure'
	end

    get "/logout" do
		session.clear
		redirect "/"
	end
end