module FourChan
	class Posts < Array
	end
	class InvalidFieldException < Exception
	end
	class Post
		Fields = %w{
			id
			date
			name
			email
			tripcode
			moderator
			text
			file
		}
		Fields.each do |field|
			attr_accessor field.to_sym
		end
		def initialize attributes
			extra = attributes.keys - Fields
			if extra.length > 0
				raise InvalidFieldException.new(
					"The supplied attributes [#{extra.join ', '}] are not valid."
				)
			end
			Fields.each do |field|
				self.instance_variable_set "@#{field}", attributes[field]
			end
		end
		def valid_attributes
			Fields.clone
		end
	end
end
