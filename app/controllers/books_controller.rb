class BooksController < ApplicationController
    get '/books' do
		if logged_in?
			@books = []
			Book.all.each do |book|
				if book.user_id == current_user.id
					@books << book
				end
			end
            erb :'/books/index'
        else
			redirect "/error"
		end
	end

	get '/books/new' do
		if logged_in?
			@book = Book.new
			erb :'/books/new'
		else
			redirect "/error"
		end
	end
	
	post '/books' do
		@book = Book.new(name: params[:name], author: params[:author], genre: params[:genre], publication_date: params[:publication_date], personal_notes: params[:personal_notes], publication_date: params[:publication_date], user_id: current_user.id)
		if @book.save
            redirect "/books/#{@book.id}"
        else
            redirect "/books/new"
        end
	end

	get '/books/:id' do
		@book = Book.find(params[:id])
		if logged_in? and @book.user_id == current_user.id
            erb :'/books/show'		
        else
			redirect "/error"
		end
	end

	get '/books/:id/edit' do
		@book = Book.find(params[:id])
		if logged_in? and @book.user_id == current_user.id
			erb :'/books/edit'
		else
			redirect "/error"
		end
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
end