Dir['tests/*.rb'].each do |test|
	`spec #{test}
end
