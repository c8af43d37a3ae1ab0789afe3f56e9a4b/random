require 'hpricot'

module FourChan

	###
	#
	# The advantage of these classes are:
	# 	* We can merge common sub-grammers
	#		  into composit grammars. abstraction = yay.
	#		* Removes the immediate coupling to Hpricot so that
	#		  we can easily change the library if need be.
	#
	###
	
	private

	class ParsedPage < Hash; end
	class ParsedPageSection < Hash; end
	class ParsedPageSectionList < Array; end

	class PageParserGrammarSegment < Hash
		attr :name
		def initialize name, values
			@name = name
			super values
		end
	end

	# Like an alias I suppose... Saves typing. Especially when nesting a bunch of them.
	PPGS = PageParserGrammarSegment

	module PageParser
		#
		# The grammar comes in the form of a nested PageParserGrammarSegment,
		# with keys as relative node references and values
		# as hashes, or names to save the values to.
		#
		# View the spec for examples of how to use the module.
		#
		#
		# TODO: Remove all references to hpricot that appear outside of this file.
		#
		#
		def self.parse doc, grammar
			dom = Hpricot::parse doc			
			result = inner_parse dom, grammar

			return ParsedPage.new(result)
		end

		private

		#
		# Recursive function for parsing a DOM
		# using a provided grammar.
		#
		def inner_parse dom, grammar
			result = ParsedPageSection.new

			grammar.each do |key,value|
				nested = PPGS === value
				inner_key = nested ? value.name : value
				result[inner_key] ||= ParsedPageSectionList.new

				(dom / key).each do |section|
					result[inner_key] << nested ? inner_parse(section,value) : audit(section)
				end
			end

			return result
		end

		#
		# Used to simplify the hpricot element into a more easily used structure.
		#
		def audit section
			section
		end

	end
end
