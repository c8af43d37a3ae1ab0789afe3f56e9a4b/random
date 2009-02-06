require 'sequel'

describe Sequel do
	it "Works with sqlite" do
		describe Sequel do
			it "can create an in memory database" do
				db = Sequel.sqlite
				describe db do
					it "should be able to create tables" do
					end
				end
			end
		end
	end
end
