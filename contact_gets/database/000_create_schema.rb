module Database

	class SetupContacts < ActiveRecord::Migration
		def self.up
			create_table :contacts do |t|
				t.string :post
				t.string :email
				t.datetime :date, :default => :sysdate
			end
		end
		def self.down
			drop_table :contacts
		end
	end

end
