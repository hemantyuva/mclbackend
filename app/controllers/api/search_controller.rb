class Api::SearchController <  Api::BaseController
  # Before action check search term
  before_action :check_serch_term, only: [:case_search,:create,:destory_search_term]
  # Before action check sort type
  before_action :check_sort_type, only: [:sort_search_cases]

  	# Search case according to the keyword
  	def case_search
	    # Search cases according to the keyword
	    cases = case_list(params[:searchterm])
      create_recent_search(params[:searchterm])
      # check condition for case is present or not.
      if cases.present?
      # response to the JSON
      render json: { success: true, response: cases.as_json('search')},:status=>200
      else
        render :json=> { success: false, message: "Case is not present." },:status=> 203
      end
  	end

    # Method for create search term
    def create
      searchterm = current_user.searches.new(:search_term=>params[:searchterm],:type=>"case")
      # check condition for searchterm is saved or not.
      if searchterm.save
      # response to the JSON
      render json: { success: true,message: "Search Term Successfully Created.", response: searchterm.as_json('search') },:status=>200
      else
        render :json=> { success: false, message: searchterm.errors },:status=> 203
      end
    end

    # Method for destroy search term
    def destory_search_term
      searchterm = current_user.searches.and({:search_term =>params[:searchterm]},{:type=>"case"}).first
      # check condition for searchterm is destroy or not.
      if searchterm.destroy
      # response to the JSON
      render json: { success: true,message: "Search Term Successfully Deleted." },:status=>200
      else
        render :json=> { success: false, message: searchterm.errors },:status=> 203
      end
    end

    # Method for show recent search keyword
    def show_recent_search
      recent_search = current_user.recent_search_term.uniq
      # check condition for recent_search is present or not.
      if recent_search.present?
      # response to the JSON
      render json: { success: true, response: recent_search.as_json},:status=>200
      else
        render :json=> { success: false, message: "Recent Search is not present." },:status=> 203
      end 
    end
    
    # Method for show saved search
    def show_saved_search
      #List of saved search term of perticular user
      saved_search_term = current_user.searches.where(:type=>"case")
      # check condition for saved_search_term is present or not.
      if saved_search_term.present?
      # response to the JSON
      render json: { success: true, response: saved_search_term.as_json},:status=>200
      else
        render :json=> { success: false, message: "Saved Search is not present." },:status=> 203
      end 
    end

   # Method for filter case using search term
  	def sort_search_cases
  		# sort the cases by latest, oldest and last week
  		cases = case_list(params[:searchterm]).send(params[:sort_type])
      # check condition for cases is present or not.
  		if cases.present?
      # response to the JSON
      render json: { success: true,response: cases.as_json('search') },:status=>200
      else
        render :json=> { success: false, message: "Case is not present." },:status=> 203
      end
  	end

   # Method for complex case search
    def complex_case_search
      user_input =params[:searchterm]
      terms = user_input.split(/(.+?)((?: and | or ))/i).reject(&:empty?)
      
      if terms.present? && (terms[0].include? "~")
        @cases = nor_case_list(terms[0].delete "~")
      else
        @cases = case_list(terms[0])
      end

      if !terms[1].nil? && terms[1].strip == "OR" && terms[2].present?
        @cases = @cases | case_list(terms[2])
      elsif !terms[1].nil? && terms[1].strip == "AND" && terms[2].present? && (terms[2].include? "~")
        @cases = @cases & nor_case_list(terms[2].delete "~")
      else
        @cases = @cases & case_list(terms[2])
      end
      
      if @cases.present?
        render json: { success: true,response: @cases.as_json('search') },:status=>200
      else
        render :json=> { success: false, message: "Case is not present." },:status=> 203
      end

    end

private
	def case_list(searchterm)
		current_user.cases.any_of(
            {:patient_id.in=>current_user.patients.where(
                :firstname=>/^#{searchterm}/i
              ).map(&:id)
            }, 
            { :diagnose_name => /^#{searchterm}/i },
            { :surgery_name => /^#{searchterm}/i }
          ).order_by(:schedule_date=> :asc)
	end

  def nor_case_list(searchterm)
    current_user.cases.nor([
          {:patient_id.in=>current_user.patients.where(
              :firstname=>/^#{searchterm.strip}/i
            ).map(&:id)
          }, 
          { :diagnose_name => /^#{searchterm.strip}/i },
          { :surgery_name => /^#{searchterm.strip}/i }]
        ).order_by(:schedule_date=> :asc)  
  end

  def check_serch_term
    # response to the JSON if searchterm is not present.
    render json: {success: false, message: 'Missing Search Term !'}, status: 400 if params[:searchterm].nil?
  end

  def check_sort_type
    # response to the JSON if sort_type is not present.
    render json: {success: false, message: 'Missing Sort Type !'}, status: 400 if params[:sort_type].nil?
  end

  # Method for save recent search keyword
  def create_recent_search(searchterm)
    #Assign searchterm to recent search term
    current_user.recent_search_term << searchterm
    # Save the search term
    current_user.save
  end

end
