def valiate(string, number = nil)
	if !string.empty? && string.scan(/\D/).empty?
		num = string.to_i
		return false if num <= 0
		return false if number != nil && num > number
		return true
	end
	return false
end