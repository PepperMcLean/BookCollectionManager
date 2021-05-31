class CreateBooks < ActiveRecord::Migration[5.1]
    def up
      create_table :books do |t|
        t.string :name
        t.string :author
        t.string :genre
        t.string :publication_date
        t.string :personal_notes
      end
    end
    
    def down
      drop_table :books
    end
end
  