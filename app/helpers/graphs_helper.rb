module GraphsHelper

	def date_range
		from = params[:from].to_time.strftime('%d').to_i
		to = params[:to].to_time.strftime('%d').to_i
		return (from..to).map{|d| d.to_i}
	end
end
