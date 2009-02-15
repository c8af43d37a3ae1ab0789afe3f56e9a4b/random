#!/usr/bin/ruby

require "../lib4chan/lib/4chan.rb"

Description_regex = %r{\b\w+/\w+/\w+\b}
Contact_regex = %r{\w+@\w+}
Gender_regex = %r{/f[^/]*/}i

@contacts = Hash.new

def parse_thread thread
	thread.posts.each do |post|
		next unless post.text

		descriptions = post.text.scan(Description_regex)
		post.text.scan(Contact_regex).each do |contact|

			if @contacts[contact]
				descriptions.each do |description|
					@contacts[contact] << description
				end
			else
				@contacts[contact] = descriptions
			end
		end
	end
end

if ARGV[0]
	thread = FourChan::Thread.new URI::parse(ARGV[0])
	parse_thread thread
else
	FourChan::homepage.threads.each do |thread|
		parse_thread thread
	end
end

@contacts.each do |email,contacts|
	puts "#{email} -> #{contacts.join ', '}" if contacts.find { |contact|
		contact =~ Gender_regex
	}
end
