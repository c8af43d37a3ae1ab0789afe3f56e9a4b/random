require File::join(
	File::split(__FILE__).first,
	'lib',
	'rp-choice.rb'
)

describe RPChoice do

	it "should exist" do
		RPChoice.should_not be(nil)
	end

	it "should run, rendering a result" do
		test_set = 1,2,3,4
		result = RPChoice.run test_set, 4

		describe result do

			it "should be a lookup" do
				result.should be_a(Hash)
			end
			
		end
		
	end

	it "should correctly accumulate statistics" do
		test_set = 1,2,3,4
		times = 4
		result = RPChoice.run test_set, times

		pp result

		times.should equal(
			result.inject(0) do |upto, (key, value)|
				key.should_not equal(nil)
				upto + value
			end
		)

	end

end
