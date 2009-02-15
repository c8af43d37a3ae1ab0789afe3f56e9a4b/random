describe FourChan::Board do
	before :all do
		threads = FourChan.homepage.threadSummaries
		@thread_summary = threads[rand(threads.length)]
	end

	it "should connect to a thread" do
		thread = @thread_summary.thread

		describe thread do
			it "should be of the right class" do
				thread.should be_a(FourChan::Thread)
			end
		end
	end

end
