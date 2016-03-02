class DateTime
	def to_readable
		strftime("%d %B %Y %I:%M %p")
	end

	def to_natural
		strftime("%B %d, %Y")
	end
end

class Date
	def to_readable
		strftime("%d %B %Y")
	end

	def to_natural
		strftime("%B %d, %Y")
	end

	def to_date_format
		strftime("%d/%m/%Y")
	end
end

class Time
	def to_readable
		strftime("%I:%M %p")
	end
end