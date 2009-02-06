#!/usr/bin/ruby

require 'hpricot'
require 'open-uri'

class String
	def spam?
		return true if self.scan(/over\s+9000/i).join.length > self.length./(2)
		return false
	end
	def mostlyASCII?
		self.asciiCount > self.length./(2)
	end
	def wordCount
		self.scan(/[a-z]{3,}/i).join.length
	end
	def asciiCount
		self.scan(/[a-z]/i).join.length
	end
	def sanitize
		regex = />>\d{9}/
		self.scan(regex).each do |match|
			puts "___Quoting: #{match}___"
		end
		self.gsub regex, ''
	end

	def to_s2 *args
		self.to_s
	end

	def unbin rev = false
		unnum /[01]/, 8, 2, rev
	end
	def unhex rev = false
		unnum /[0-9a-fA-F]/, 2, 16, rev
	end
	def unoct rev = false
		unnum /\d/, 3, 8, rev
	end

	private
	def unnum set, len, num, rev = false
		self.scan(set).join.scan(/\d{#{len}}/).map do |b|
			if rev
				b.reverse.to_i num
			else
				b.to_i num
			end
		end . pack "c*"
	end
end


dom = Hpricot::parse open(ARGV[0])

( dom / "td.reply" ).reverse.each do |reply|
	puts "----------------------- #{reply.attributes['id']} ------------------------"
	( reply / "blockquote" ).each do |post|
		text = post.inner_text.sanitize

		unless text
			puts "___Empty___"
			next
		end

		if text.spam?
			puts "___Spamming___"
			next
		end

		lookup = {}

		method = [
			:unbin,
			:unoct,
			:unhex,
			:to_s2
		].sort_by do |method|
			callcc do |loo|
				un =  text.send method
				un2 = text.send method, true

				una1 = un.asciiCount.to_f
				una2 = un2.asciiCount.to_f

				if una1 >= una2
					if un.length == 0
						lookup[method] = ""
						loo.call 0
					end
					lookup[method] = un
					una1 / un.length.to_f
				else
					lookup[method] = un2
					una2 / un2.length.to_f
				end
			end # callcc
		end . last

		if method == :to_s2
			puts "___Plain Text___"
			puts lookup[method]
		else
			puts "___#{method}___"
			puts lookup[method].inspect
		end
	end
end
