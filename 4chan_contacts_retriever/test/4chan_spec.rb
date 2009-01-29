require 'lib/4chan.rb'

describe FourChan do
	before :each do
		@fourchan = FourChan.new
	end

	it "should contain these methods" do
		@fourchan.should respond_to(:home)
		@fourchan.should respond_to(:homepage)

		@fourchan.should respond_to(:board)
		@fourchan.should respond_to(:boards)

		@fourchan.should respond_to(:thread)
	end

end
