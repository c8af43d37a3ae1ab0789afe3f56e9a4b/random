module RPChoice
	def self.run set, limit = 1.0 / 0.0, &block
		stats = {}

		other_set = []

		(0 ... limit).each do |index|
			# pick a guy

			set_length = set.length
			combined_length = set_length + other_set.length

			element_index = rand combined_length

			element = if element_index < set_length
				set[element_index]
			else
				other_set[element_index - set_length]
			end

			other_set << element

			stats[element] ||= 0
			stats[element] += 1

			block.call index, element, stats if block

		end

		stats

	end
end
