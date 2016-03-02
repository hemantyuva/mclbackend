class Api::QuestionAdvanceSearchController < Api::BaseController
  # before action need to check the session time out
  before_action :check_max_session_time
  # before action need to check the user is existed or not
  before_action :find_logged_user
  
	def index
		#List of recent search term of perticular user
		recent_saved_search = []
      	recent_search_term = current_user.question_recent_search_term.reverse.uniq.reject(&:blank?)
      	saved_search_term = current_user.searches.where(:type=>"question")
        recent_saved_search = recent_search_term + saved_search_term
      	if recent_saved_search.present?
	    	render :json=> {success: true, :response => recent_saved_search.as_json('question_data') },:status=> 200
	      # render json: { success: true, response: @questions.map{ |f| QuestionSerializer.new(f).as_json( root: false ) } }
	    else
	      render :json=> { success: false, message: "Questions are not present" },:status=> 203
	    end
	end

	# Method for search questions 
	def search_questions
		# Search question according to the keyword
		questions = question_list(params[:searchterm])
		create_recent_search(params[:searchterm])
		if questions.present?
	    	render :json=> {success: true, :response => questions.as_json('question_data') },:status=> 200
	      # render json: { success: true, response: @questions.map{ |f| QuestionSerializer.new(f).as_json( root: false ) } }
	    else
	      render :json=> { success: false, message: "Questions are not present" },:status=> 203
	    end
	end

	# Method for show recent search keyword
    def show_recent_search
      recent_search = current_user.question_recent_search_term.uniq.reject(&:blank?)
      # check condition for recent_search is present or not.
      if recent_search.present?
      # response to the JSON
      render json: { success: true, response: recent_search.as_json},:status=>200
      else
        render :json=> { success: false, message: "Recent Search is not present." },:status=> 203
      end 
    end

    def show_saved_search
      	#List of saved search term of perticular user
     	saved_search_term = current_user.searches.where(:type=>"question")
        # check condition for saved_search_term is present or not.
		if saved_search_term.present?
			# response to the JSON
			render json: { success: true, response: saved_search_term.as_json},:status=>200
		else
			render :json=> { success: false, message: "Saved Search is not present." },:status=> 203
		end 
    end

  	#Method for save search keyword
  	def create
  		searchterm = current_user.searches.new(:search_term=>params[:searchterm],:type=>"question")
  		# check condition for searchterm is saved or not.
      if searchterm.save
      # response to the JSON
      	render json: { success: true,message: "Search Term Successfully Created.", response: searchterm.as_json('search') },:status=>200
      else
        render :json=> { success: false, message: searchterm.errors },:status=> 203
      end
  	end

  	#Method for destroy search keyword
  	def destory_search_term
  		searchterm = current_user.searches.and({:search_term =>params[:searchterm]},{:type=>"question"}).first
  		# check condition for searchterm is destroy or not.
	    if searchterm.destroy
	    # response to the JSON
	    render json: { success: true,message: "Search Term Successfully Deleted." },:status=>200
	    else
	    render :json=> { success: false, message: searchterm.errors },:status=> 203
	    end
  	end

  	 def complex_question_search
	    user_input =params[:searchterm]
	    terms = user_input.split(/(.+?)((?: and | or ))/i).reject(&:empty?)
	      
	    if terms.present? && (terms[0].include? "~")
	        @questions = nor_question_list(terms[0].delete "~")
	    else
	        @questions = question_list(terms[0])
	    end

	    if !terms[1].nil? && terms[1].strip == "OR" && terms[2].present?
	        @questions = @cases | question_list(terms[2])
	    elsif !terms[1].nil? && terms[1].strip == "AND" && terms[2].present? && (terms[2].include? "~")
	        @questions = @questions & nor_question_list(terms[2].delete "~")
	    else
	        @questions = @questions & question_list(terms[2])
	    end
        
        if @questions.present?
	      render json: { success: true,response: @questions.as_json("question_data") },:status=>200
	    else
	      render :json=> { success: false, message: "Question is not present." },:status=> 203
	    end
	    
    end

private

	# Method for save recent search keyword
  	def create_recent_search(searchterm)
	    #Assign searchterm to question_recent_search_term
	    current_user.question_recent_search_term << params[:searchterm]
	    # Save the search term
	    current_user.save
  	end

  	def question_list(searchterm)
  		Question.any_of({ :title => /^#{searchterm}/i },
  			{:tags => /^#{searchterm}/i })
  	end

    def nor_question_list(searchterm)
    	Question.nor([{ :title => /^#{searchterm.strip}/i },
  			{:tags => /^#{searchterm.strip}/i }])
    end

end
