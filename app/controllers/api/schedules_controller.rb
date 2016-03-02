class Api::SchedulesController < Api::BaseController
	 # before action need to check the schedle list method
	before_action :case_list,only: [:index]
	respond_to :json


	# Method for list out all the surgery created by surgeon 
	def index
		if @cases.present?
      		render json: { success: true, response: @cases.as_json("case_media") },:status=> 200
	    else
	        render :json=> { success: false, message: "Cases are not present" },:status=> 203
	    end
	end


private
	# Method for the showing the all schedules
	def case_list
		# listing the all the schedule cases with surgeon with ascending schedule date
		@cases = current_user.cases.order_by(:schedule_date=> :asc).collect{|surgery_case| surgery_case if surgery_case.schedule.schedule_date.to_date.future? || surgery_case.schedule.schedule_date.to_date.today?}.compact
	end
end
