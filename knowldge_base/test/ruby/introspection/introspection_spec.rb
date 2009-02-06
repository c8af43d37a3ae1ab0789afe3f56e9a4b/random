describe "ruby introspection" do
	it "should allow detection of module inclusion" do
		# Module#included:
		module Hook1
			def self.included(in_what)
				in_what.flag!
			end
		end
		class Test1
			@@flag = false
			def self.flag!
				@@flag = true
			end
			def self.flag
				@@flag
			end
			include Hook1
		end
		Test1.flag.should_not be_nil
	end

	it "should allow detection of inheritance" do
		# Class#inherited:
	
		class Hook2
			@@flag = false
			def self.flag!
				@@flag = true
			end
			def self.flag
				@@flag
			end
			# --
			def self.inherited(by_what)
				by_what.flag!
			end
		end
		class Test2 < Hook2
		end
		Test2.flag.should_not be_nil
	end

	it "should allow detection of method definition" do
		# Module#method
		class Parent
			@@flag = false
			def self.flag!
				@@flag = true
			end
			def self.flag
				@@flag
			end
			# --
			def self.method_added(method_name)
				puts method_name
			end
		end
		class Test3 < Parent
			def hello
			end
		end
		Test3.flag.should_not be_nil
	end
end
