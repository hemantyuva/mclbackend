class SearchController < ApplicationController
    # Before action need to find the user type
    before_action :check_admin
    # before action need to check the session time out
    before_action :check_max_session_time
    # before action need to check the user is existed or not
    before_action :find_logged_user
    after_action :check_saved_search,only: [:create]

    #Method for save search keyword
  	def create
  		@searchterm = current_user.searches.create(:search_term=>params[:searchterm],:type=>"case")
    end

    #Method for destroy search keyword
  	def destory_search_term
  		current_user.searches.and({:search_term =>params[:searchterm]},{:type=>"case"}).first.destroy
  	end
  	
    # Method for save recent search keyword
  	def create_recent_search
 		  current_user.recent_search_term << params[:searchterm]
  		current_user.save
  	end

  	# Search case according to the keyword
  	def case_search
      @case_search = true
  		@searchterm = current_user.searches.and({:search_term =>params[:searchterm]},{:type=>"case"}).first
	    # Search cases according to the keyword
	    @cases = case_list(params[:searchterm]).paginate(page: params[:page],per_page: 20)
	    # respond_to the the js file
	    respond_to do |format|
	      format.js
	    end
  	end

  	def sort_search_cases
  		# sort the cases by latest, oldest and last week
  		@cases = case_list(params[:searchterm]).send(params[:sort_type])
  		# respond_to the the js file
	    respond_to do |format|
	      format.js
	    end
  	end

    #Method to show advance search options
  	def advance_search
  		@cases = current_user.cases.all
      #List of recent search term of perticular user
      @recent_search_term = current_user.recent_search_term.reverse.uniq
  	end

    #Method for show resent keyword searched by particular user 
  	def show_recent_search
      #List of recent search term of perticular user
  		@recent_search_term = current_user.recent_search_term.reverse.uniq
  		# respond_to the the html file
      respond_to do |format|
  			format.html do
  				render "show_recent_search", layout: false
  			end
		  end
  	end

    def show_saved_search
      #List of saved search term of perticular user
      @saved_search_term = current_user.searches.where(:type=>"case")
      # respond_to the the html file
      respond_to do |format|
        format.html do
          render "show_saved_search", layout: false
        end
      end
    end

    def show_complex_search
      @graph_search = params[:graph_search]
      respond_to do |format|
        format.html do
          render "show_complex_search", layout: false
        end
      end
    end

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

    def check_saved_search
      devise_current_user.preferrence.saved_search << params[:searchterm]
      devise_current_user.preferrence.save
    end
  
end
