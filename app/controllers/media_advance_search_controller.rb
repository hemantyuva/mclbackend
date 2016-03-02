class MediaAdvanceSearchController < ApplicationController
	# Before action need to find the user type
	before_action :check_admin
	# before action need to check the session time out
	before_action :check_max_session_time
	# before action need to check the user is existed or not
	before_action :find_logged_user

  	#Method to show advance search options
  	def index
      	#List of recent search term of perticular user
      	@recent_search_term = current_user.media_recent_search_term.reverse.uniq
  	end

    #Method for save search keyword
  	def create
  		@searchterm = current_user.searches.create(:search_term=>params[:searchterm],:type=>"media")
  	end

    #Method for destroy search keyword
  	def destory_search_term
  		current_user.searches.and({:search_term =>params[:searchterm]},{:type=>"media"}).first.destroy
  	end
  	
    # Method for save recent search keyword
  	def create_recent_search
   		current_user.media_recent_search_term << params[:searchterm]
    	current_user.save
  	end

  	#Method for show resent keyword searched by particular user 
  	def show_recent_search
      #List of recent search term of perticular user
  		@recent_search_term = current_user.media_recent_search_term.reverse.uniq
  		# respond_to the the html file
	    respond_to do |format|
  			format.html do
  				render "show_recent_search", layout: false
  			end
		  end
  	end

    def show_saved_search
      	#List of saved search term of perticular user
     	@saved_search_term = current_user.searches.where(:type=>"media")
      	# respond_to the the html file
	    respond_to do |format|
	        format.html do
	          render "show_saved_search", layout: false
	        end
	    end
    end
    
    def complex_media_search
      @complex_search = true
	    user_input =params[:searchterm]
	    terms = user_input.split(/(.+?)((?: and | or ))/i).reject(&:empty?)
	      
	    if terms.present? && (terms[0].include? "~")
	        @case_media = nor_media_list(terms[0].delete "~")
	    else
	        @case_media = media_list(terms[0])
	    end

	    if !terms[1].nil? && terms[1].strip == "OR" && terms[2].present?
	        @case_media = @case_media | media_list(terms[2])
	    elsif !terms[1].nil? && terms[1].strip == "AND" && terms[2].present? && (terms[2].include? "~")
	        @case_media = @case_media & nor_media_list(terms[2].delete "~")
	    else
	        @case_media = @case_media & media_list(terms[2])
	    end
    end

    private
  	
  	def media_list(searchterm)
  		CaseMediaAttachment.where(
			:case_medium_id.in=>current_user.case_media.map(&:id),
			:tags => /^#{searchterm}/i
      	)
  	end

    def nor_media_list(searchterm)
    	CaseMediaAttachment.where(:case_medium_id.in => current_user.case_media.map(&:id),
  			:tags.not => /^#{searchterm.strip}/i )
    end
end
