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

    get "/home" do
		if logged_in?
			erb :home
		else
			redirect "/error"
		end
	end

    get "/error" do
        erb :error
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