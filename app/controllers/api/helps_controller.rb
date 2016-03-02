class Api::HelpsController < Api::BaseController
	
  skip_before_filter :verify_user,:has_passcode?

#method to help content
	def create
    	# Intialize the help add video params
       help = Help.new(title: params[:title], url: params[:url])
    	# After Initialize the help save the help
      if help.save
      # response to the JSON
    	render json: { success: true,message: "Help Successfully Created.", response: HelpSerializer.new(help).as_json(root: false) },:status=>200
	    else
	      render :json=> { success: false, message: help.errors },:status=> 203
	    end
  	end

end
