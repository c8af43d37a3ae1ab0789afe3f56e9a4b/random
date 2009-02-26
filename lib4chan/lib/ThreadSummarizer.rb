module FourChan
	private
	module ThreadSummarizer
		def threadSummaries
			@thread_summaries
		end
		def threads
			@thread_summaries.map do |summary|
				summary.thread
			end
		end
	end
end
