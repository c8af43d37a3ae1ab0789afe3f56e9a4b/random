class Thread
	include DataMapper::Resource
	property :id, String, :key => true

	has n :posts
end
