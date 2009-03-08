require 'dm-core'
require 'pp'

describe "Helper Classes" do
	module Enumerable
		def rand
			self[Kernel::rand(self.length)]
		end
	end
	class FormHelper
		@@dictionary = File::read('/usr/share/dict/words').split(/\s+/)

		class << self
			def random_new_form_arguments

				name = random_sentence(1 + rand(5)) + ' form'
				description = random_sentence(12)

				return {
					:name => name,
					:description => description
				}
			end

			alias rand_new_user_type_arguments random_new_form_arguments
			alias rand_new_owner_arguments random_new_form_arguments

			def rand_new_contact_arguments

				hash = random_new_form_arguments

				hash[:telephone] = random_string(('0' .. '9').to_a.join, 9)
				hash[:fax] = random_string(('0' .. '9').to_a.join, 9)
				hash[:email] = "#{random_sentence(3,'_')}@#{random_sentence(2,"-")}.com"

				return hash
			end

			def random_sentence length, delimiter = " "
				Array.new(length).map {
					random_word
				}.join(delimiter).capitalize
			end

			def random_word
				@@dictionary.rand.downcase
			end

			def random_string character_set, length
				characters = character_set.split //
				Array.new(length).map{character_set.rand}.join
			end
		end
	end
end

describe DataMapper do
	before :all do
		db_file = "/#{Dir.pwd}/test.db"
		File::delete db_file if File::exists? db_file
		@DM = DataMapper.setup :default, "sqlite3://#{db_file}"
	end

	it "should be able to represent the forms project as a class structure" do
		class BaseType
			include DataMapper::Resource

			property :class, Discriminator, :index => true

			property :id, Serial, :unique_index => true
			property :name, String
			property :description, Text
			property :created, Date, :default => lambda {Time.now}
			property :active, Boolean, :default => true
		end
		class Form < BaseType
			has n, :user_types, :class_name => "UserType", :through => Resource
			has n, :owners, :through => Resource
		end
		class UserType < BaseType
		end
		class Owner < BaseType
			has n, :contacts, :through => Resource
		end
		class Contact < BaseType
			property :name, String
			property :telephone, String
			property :fax, String
			property :email, String
		end
	end

	it "should set up the database correctly" do 
		DataMapper::auto_migrate!
	end

	it "should create user types correctly" do
		10.times do
			user_type = UserType.new FormHelper.rand_new_user_type_arguments
			user_type.save
		end
	end

	it "should create contacts correctly" do
		10.times do
			contact = Contact.new FormHelper.rand_new_contact_arguments
			contact.save
		end
	end

	it "should create owners correctly" do
		16.times do
			owner = Owner.new FormHelper.rand_new_owner_arguments
			owner.save
		end
	end

	it "should create forms correctly" do
		# Generate 100 forms
		100.times do
			form = Form.new FormHelper.random_new_form_arguments
			form.save
		end
	end

	it "should associate types to forms correctly" do
		forms = Form.all
		{
			:user_types => UserType,
			:owners => Owner
		}.each do |method, klass|
			set = klass.all

			forms.each do |form|
				# assign a random user type to a form
				form.send(method) << set.rand
				form.save
			end
		end
	end

end
