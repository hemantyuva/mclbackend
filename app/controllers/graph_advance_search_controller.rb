class GraphAdvanceSearchController < ApplicationController
	# Before action need to find the user type
	before_action :check_admin
	# before action need to check the session time out
	before_action :check_max_session_time
	# before action need to check the user is existed or not
	before_action :find_logged_user

	#Method to show advance search options
  	def index
      #List of recent search term of perticular user
      @recent_search_term = current_user.graph_search_term.reverse.uniq
  	end

    #Method for save search keyword
  	def create
  		@searchterm = current_user.searches.create(:search_term=>params[:searchterm],:type=>"graph")
  	end

    #Method for destroy search keyword
  	def destory_search_term
  		current_user.searches.and({:search_term =>params[:searchterm]},{:type=>"graph"}).first.destroy
  	end

    def advance_search_graph
      @recent_search_term = current_user.graph_search_term.reverse.uniq
      respond_to do |format|
        format.js
      end

    end
  	
    # Method for save recent search keyword
  	def create_recent_search
   		current_user.graph_search_term << params[:searchterm]
    	current_user.save
  	end

  	#Method for show resent keyword searched by particular user 
  	def show_recent_search
      #List of recent search term of perticular user
  		@recent_search_term = current_user.graph_search_term.reverse.uniq
  		# respond_to the the html file
	    respond_to do |format|
  			format.html do
  				render "show_recent_search", layout: false
  			end
		  end
  	end

    def show_saved_search
      #List of saved search term of perticular user
     	@saved_search_term = current_user.searches.where(:type=>"graph")
      	# respond_to the the html file
	    respond_to do |format|
	        format.html do
	          render "show_saved_search", layout: false
	        end
	    end
    end
    
    def complex_graph_search
        # getting the all the params which is type from user
        term = params[:term]
        # condition for checking the params having tilda operator or not
        if term[0] == "~"
          # if there then do the not operations
          term = term.gsub(/[~]/, '')
          # checking the not tags
          @surgery_case = nor_case_search(term.split(", ")) rescue []
        else
          # else check the normal tags which is typed from ui
          @surgery_case = case_search(params[:term].split(", ")) rescue []
        end

        if !(params[:from].blank?) && !(params[:to].blank?)
          tags_date_range
        else
          cases_dates_integer = @surgery_case.collect{|p| Time.parse(p.surgery_date.strftime("%d-%m-%Y")).to_i}.uniq
          cases_tags = @surgery_case.collect{|p| p.surgery_name}.uniq
          @tags_cases_count = cases_tags.collect{|p| {:name=>p, :data=>cases_dates_integer.collect{|q| @surgery_case.collect{|r| r if (r.surgery_name==p && Time.parse(r.surgery_date.strftime("%d-%m-%Y")).to_i==q) }.reject(&:blank?).count } }}
          @cases_dates = cases_dates_integer.collect{|p| Time.at(p).strftime("%d-%m-%Y")}
        end
    		respond_to do |format|
    		  format.js 
    		end
    end

    private
  	
    def case_search(searchterm)
      current_user.cases.where(:surgery_name.in => searchterm)
    end

    def nor_case_search(searchterm)
     current_user.cases.not_in(:surgery_name => searchterm)
   end

   def tags_date_range
      from_date = Time.parse(params[:from] || (Time.now - 7.days).strftime("%d-%m-%Y"))
      to_date = Time.parse(params[:to] || Time.now.strftime("%d-%m-%Y"))+1.day
      my_cases = @surgery_case.collect{|p| p if from_date <=p.surgery_date && p.surgery_date<=to_date}.reject(&:blank?)
      cases_dates_integer = my_cases.collect{|p| Time.parse(p.surgery_date.strftime("%d-%m-%Y")).to_i}.uniq
      cases_tags = my_cases.collect{|p| p.surgery_name}.uniq
      @tags_cases_count = cases_tags.collect{|p| {:name=>p, :data=>cases_dates_integer.collect{|q| my_cases.collect{|r| r if (q<=Time.parse(r.surgery_date.strftime("%d-%m-%Y")).to_i && Time.parse(r.surgery_date.strftime("%d-%m-%Y")).to_i<=q && r.surgery_name==p) }.reject(&:blank?).count } }}
      @cases_dates = cases_dates_integer.collect{|p| Time.at(p).strftime("%d-%m-%Y")}
   end
end
