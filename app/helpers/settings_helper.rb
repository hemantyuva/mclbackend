module SettingsHelper

	def session_time_check timeout
		if timeout == "24"
			@timeout_one_day = timeout
		elsif timeout == "48"
			@timeout_two_days = timeout
		elsif timeout == "Always"
			@timeout_always = timeout
		elsif timeout == "Unless"
			@timeout_unless = timeout
		end
	end
end
