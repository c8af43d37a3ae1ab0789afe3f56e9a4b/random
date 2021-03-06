#!/usr/bin/ruby

require 'sqlite3'
require 'activerecord'
require 'pp'

ActiveRecord::Base.allow_concurrency = true

describe ActiveRecord do

	before :all do

		DB_FILE = 'activeRecordTest.db'
		DB = SQLite3::Database.new DB_FILE

		module Schema
			class SetupPeople < ActiveRecord::Migration
				def self.up
					create_table :people do |t|
						t.string :name
					end
				end
				def self.down
					drop_table :people
				end
			end
		end

	end

	after :all do
		File::delete DB_FILE
	end

	it "should connect to the database correctly" do
		ActiveRecord::Base.establish_connection(
			:adapter => 'sqlite3',
			:database => DB_FILE
			# :database => ":memory"
		)
	end

	it "shout create tables using migrations" do
		Schema::SetupPeople.migrate :up
	end

	it "should create records in the database" do
		# Define the serializable classes
		
		class Person < ActiveRecord::Base
			set_table_name 'people'
		end

		# Create some stuff

		p1 = Person.find_or_initialize_by_name "Joe Schmoe"
		p1.name = "Joe Blow"
		p1.save

	end

end
