describe FourChan::Board do
	before :all do
		threads = FourChan.homepage.threadSummaries
		thread_summary = threads[rand(threads.length)]
		@board = thread_summary.board
	end

	it "should appear correct" do
		describe board do
			it "should be of the right class" do
				@board.should be_a(FourChan::Board)
			end
		end
	end

	it "should get a get" do
		attempting_id = @board.max_id + 50 + rand(51)
		post = @board.get attempting_id
		post.id.shoud equal(attempting_id)
	end

	it "should support posting" do
		describe @board do
			options = {
				:message => "testing #{rand}"
			}

			thread = @board.post options

			it "should be OP of the thread" do
				options.should be_a_subset_of(thread.op)
			end
		end
	end

	it "should support paging" do
		describe @board do
			it "should have pages" do
				@board.pages.should be(Enumerable)
				@board.pages.first.should be(FourChan::BoardPage)
			end
		end
	end

end
