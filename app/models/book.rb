class Book < ActiveRecord::Base
    belongs_to :user
    validates_presence_of :name, :author, :genre, :publication_date, :personal_notes
end