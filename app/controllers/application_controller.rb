require_relative '../../config/environment'
class ApplicationController < Sinatra::Base
    configure do
        set :views, "app/views"
        enable :sessions
        set :session_secret, "n[K#!PF!c.E6w%0f-z(Cn7|&paOoE6hVrvXkzM=#V-Vp5ITt.fL2,cAF~;[yva;"
    end

    get '/' do
		if logged_in?
			redirect "/home"
		else
			erb :welcome
		end
    end

    get '/signup' do 
        erb :signup
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
		erb :taken
	end

    get "/login" do
        erb :login
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

    get "/home" do
		if logged_in?
			erb :home
		else
			redirect "/error"
		end
	end

	get '/books/show' do
		if logged_in?
			@books = []
			Book.all.each do |book|
				if book.user_id == current_user.id
					@books << book
				end
			end
			erb :show
		else
			redirect "/error"
		end
	end

	get '/books/new' do
		if logged_in?
			@book = Book.new
			erb :new
		else
			redirect "/error"
		end
	end
	
	post '/books' do
		@book = Book.create(name: params[:name], author: params[:author], genre: params[:genre], publication_date: params[:publication_date], personal_notes: params[:personal_notes], publication_date: params[:publication_date], user_id: current_user.id)
		redirect to "/books/#{@book.id}"
	end

	get '/books/:id' do
		@book = Book.find(params[:id])
		if logged_in? and @book.user_id == current_user.id
			erb :show_id
		else
			redirect "/error"
		end
	end

	get '/books/:id/edit' do
		@book = Book.find(params[:id])
		if logged_in? and @book.user_id == current_user.id
			erb :edit
		else
			redirect "/error"
		end
	end

	get "/failure" do
		erb :failure
	end

    get "/logout" do
		session.clear
		redirect "/"
	end

    get "/error" do
        erb :error
    end

	patch '/books/:id' do
		id = params[:id]
		@book = Book.find_by(id: id)
		attrs = params[:book]
		@book.update(attrs)
		redirect to "/books/#{@book.id}"
	end

	delete '/books/:id' do
		Book.delete(params[:id])
		redirect to "/home"
	end
	
    helpers do
		def logged_in?
			!!session[:user_id]
		end

		def current_user
			User.find(session[:user_id])
		end
	end
end