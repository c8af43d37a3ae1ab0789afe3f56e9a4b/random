require 'lib/4chan.rb'

describe FourChan do
	before :each do
		@fourchan = FourChan.new
	end

	it "should fetch the homepage" do
		homepage = @fourchan.home

		describe homepage do
			it "should be of the right class" do
				homepage.should be_a(FourChan::Homepage)
			end

			it "should contain summaries of the active threads" do
				active_thread_summaries = homepage.threadSummaries

				describe active_thread_summaries do
					it "should be of the right class" do
						active_thread_summaries.should be_a(FourChan::ThreadSummaries)
					end

					it "should contain thread summaries" do
						active_thread_summaries.length.should > 0
					end
					
					it "should contain valid thread summaries" do
						active_thread_summaries.each do |summary|
							describe summary do
								it "should be of the right class" do
									summary.should be_a(FourChan::ThreadSummary)
								end

								summary.unique_public_methods.reject{|m| m =~ /=$|thread/}.each do |key|
									it "should have this accessor method" do
										summary.should respond_to(key)
									end

									it "should be populated with :#{key}" do
										summary.send(key).should_not be_nil
									end

								end

							end
						end
					end
				end
			end
		end
	end
end

class Object
	def unique_public_methods
		s_class = self.class.superclass
		methods - (s_class.instance_methods + s_class.methods)
	end
end
