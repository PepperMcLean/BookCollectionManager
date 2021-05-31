require_relative '../../config/environment'
class ApplicationController < Sinatra::Base
    configure do
        set :views, Proc.new { File.join(root, "../views/") }
        enable :sessions unless test?
        set :session_secret, "secret"
    end

    get '/' do 
        erb :welcome
    end

    get '/signup' do 
        erb :signup
    end

    post "/signup" do
		user = User.new(:username => params[:username], :password => params[:password])
		if user.save
			redirect "/login"
		else
			redirect "/failure"
		end
	end
end