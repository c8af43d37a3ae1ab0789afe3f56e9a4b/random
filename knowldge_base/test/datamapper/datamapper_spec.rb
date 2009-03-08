require 'dm-core'
require 'pp'

describe DataMapper do

	before :all do
		@DM = DataMapper.setup(:default, 'sqlite3::memory:')
		# pp @DM
	end

	after :all do
	end

	it "Should integrate into existing object classes" do
		class Person
			include DataMapper::Resource
			property :name, String, :key => true
			property :age, Float
		end
	end

	it "should create tables for classes that include it" do
		Person.auto_migrate!
		# DataMapper.auto_migrate!
	end

	it "should allow objects of classes that include it to be created and destroyed" do
		person = Person.new :name => "Joe", :age => "55"
		describe person do
			it "should save state" do
				person.save
			end
			it "should be able to be searched for" do
				person.should == Person.first(:name => "Joe")
			end
			it "should return identical object references" do
				Person.first(:name => "Joe").object_id.should == Person.first(:name => "Joe").object_id
			end
			it "should be able to be deleted" do
				person.destroy
				found_person = nil
				Person.all(:name => "Joe").each do |found_person_record|
					found_person = found_person_record
				end
				found_person.should == nil
			end # should be able to be deleted
		end # describe person
	end # should allow objects of classes that include it to be created and destroyed

	it "Should allow associations between classes" do
		class Room
			include DataMapper::Resource
			property :id, Serial

			has n, :people, :class_name => "Person"
		end
		Room.auto_migrate!
	end

	it "Should allow associations between objects based on class associations" do
		room = Room.new
		person = room.people.build :name => "Dan", :age => 45
		person.save

		room.people.all.length.should == 1

		room.people.first.should == person
	end

end
