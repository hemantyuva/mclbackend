class Api::GraphsController < Api::BaseController
	before_action :case_bar_chart, only: [:date_range,:date_line_chart]
	before_action :case_line_chart, only: [:quick_stats, :quick_stats_line_chart]

	def date_range
		render json: { success: true, response: {"cases count on a particular dates": @surgery_cases.as_json} },:status=>200
 	end

	def quick_stats
		render json: { success: true, response: {"cases count on a particular dates": @surgery_cases.as_json} },:status=>200
	end

	def tags_date_range
		@searchterm = current_user.searches.and({:search_term =>params[:term]},{:type=>"graph"}).first
		create_recent_search(params[:term])
		@surgery_case = case_search(params[:term].split(", ")) rescue []
		if params[:date].blank?
			from_date = Time.parse(params[:from] || (Time.now - 7.days).strftime("%d-%m-%Y"))
			to_date = Time.parse(params[:to] || Time.now.strftime("%d-%m-%Y"))+1.day
		else
			from_date = Date.new( params[:date].split("-")[1].to_i, params[:date].split("-")[0].to_i,1) rescue Date.new( Time.now.year, Time.now.month,1)
			to_date = Date.new( params[:date].split("-")[1].to_i, params[:date].split("-")[0].to_i,-1) rescue Date.new( Time.now.year, Time.now.month,-1)
		end
		
		my_cases = @surgery_case.collect{|p| p if from_date <=p.schedule.schedule_date && p.schedule.schedule_date<=to_date}.reject(&:blank?)
		
		cases_dates_integer = my_cases.collect{|p| Time.parse(p.schedule.schedule_date.strftime("%d-%m-%Y")).to_i}.uniq
		cases_tags = my_cases.collect{|p| p.surgery_name}.uniq
		@tags_cases_count = cases_tags.collect{|p| {:name=>p, :data=>cases_dates_integer.collect{|q| my_cases.collect{|r| r if (q<=Time.parse(r.schedule.schedule_date.strftime("%d-%m-%Y")).to_i && Time.parse(r.schedule.schedule_date.strftime("%d-%m-%Y")).to_i<=q && r.surgery_name==p) }.reject(&:blank?).count } }}
 		@cases_dates = cases_dates_integer.collect{|p| Time.at(p).strftime("%d-%m-%Y")}
        render json: { success: true, response: {date: @cases_dates.as_json,dignosis: @tags_cases_count.as_json } },:status=>200
		
	end

	def date_line_chart
		render json: { success: true, response: {"cases count on a particular dates": @surgery_cases.as_json} },:status=>200
	end

	def quick_stats_line_chart
		render json: { success: true, response: {"cases count on a particular dates": @surgery_cases.as_json} },:status=>200
	end

	def date_bar_chart
		respond_to do |format|
		  format.js 
		  format.html
		end
	end

	def quick_stats_bar_chart
		respond_to do |format|
		  format.js 
		  format.html
		end
	end

	def show_cases
		cases = current_user.cases.collect{|c| c if c.schedule.schedule_date.strftime("%d-%m-%Y") ==  params[:date]}.reject(&:blank?)
		cases = current_user.cases.any_of({ :diagnose_name => params[:searchterm]},{ :surgery_name => params[:searchterm]}) if params[:date].nil?
		render json: { success: true, response: cases.as_json("graph_show_case") },:status=>200
	end

	private

	def case_bar_chart
		from_date = Time.parse(params[:from] || (Time.now - 7.days).strftime("%d-%m-%Y"))
		to_date = Time.parse(params[:to] || Time.now.strftime("%d-%m-%Y"))+1.day
		case_chart(from_date, to_date)
	end

	def case_line_chart
		from_date = Date.new( params[:date].split("-")[1].to_i, params[:date].split("-")[0].to_i,1) rescue Date.new( Time.now.year, Time.now.month,1)
		to_date = Date.new( params[:date].split("-")[1].to_i, params[:date].split("-")[0].to_i,-1) rescue Date.new( Time.now.year, Time.now.month,-1)
		case_chart(from_date, to_date)
	end

	def case_chart(from_date, to_date)
		my_cases=current_user.cases.collect{|p| {p.id.to_s=>Time.parse(p.schedule.schedule_date.strftime("%d-%m-%Y")).to_i} if from_date <=p.schedule.schedule_date && p.schedule.schedule_date<=to_date}.reject(&:blank?)
		@surgery_cases=Hash.new(0)
		my_cases.collect{|p| @surgery_cases[p.values[0]]+=1}
		@surgery_cases = @surgery_cases.sort.collect{|p| [Time.at(p[0]).strftime("%d-%m-%Y"), p[1]]}.flatten
		@surgery_cases = Hash[*@surgery_cases]
	end

	def case_search(searchterm)
		current_user.cases.where(:surgery_name.in => searchterm)
	end

	# Method for save recent search keyword
  	def create_recent_search(searchterm)
   		current_user.graph_search_term << searchterm
    	current_user.save
  	end

end
