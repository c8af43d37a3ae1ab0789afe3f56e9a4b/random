class Post
	include DataMapper::Resource
	property :id, String, :key => true
	property :date, Date
	property :name, String
	property :email, String
	property :tripcode, String
	property :text, Text

	belongs_to :thread
end
