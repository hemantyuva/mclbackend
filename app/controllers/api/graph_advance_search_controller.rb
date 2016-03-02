class Api::GraphAdvanceSearchController < Api::BaseController

	#Method to show advance search options
  	def index
    	#List of recent search term of perticular user
    	recent_search_term = current_user.graph_recent_search_term.reverse.uniq
      if recent_search_term.present?
      # response to the JSON
        render json: { success: true, response: recent_search_term.as_json },:status=>200
      else
        render :json=> { success: false, message: recent_search_term.errors },:status=> 203
      end
  	end

    #Method for save search keyword
  	def create
  		searchterm = current_user.searches.new(:search_term=>params[:searchterm],:type=>"graph")
  		# check condition for searchterm is saved or not.
      if searchterm.save
      # response to the JSON
        render json: { success: true,message: "Search Term Successfully Created.", response: searchterm.as_json },:status=>200
      else
        render :json=> { success: false, message: searchterm.errors },:status=> 203
      end
  	end

    #Method for destroy search keyword
  	def destory_search_term
  		searchterm = current_user.searches.and({:search_term =>params[:searchterm]},{:type=>"graph"}).first
  		if searchterm.destroy
      # response to the JSON
        render json: { success: true,message: "Search Term Successfully Deleted." },:status=>200
      else
        render :json=> { success: false, message: searchterm.errors },:status=> 203
      end
  	end
  

  	#Method for show resent keyword searched by particular user 
  	def show_recent_search
      #List of recent search term of perticular user
  		recent_search_term = current_user.graph_search_term.reverse.uniq
  		if recent_search_term.present?
       # response to the JSON
          render json: { success: true, response: recent_search_term.as_json},:status=>200
        else
          render :json=> { success: false, message: "Recent term is not present." },:status=> 203
        end 
  	end

    def show_saved_search
      #List of saved search term of perticular user
     	saved_search_term = current_user.searches.where(:type=>"graph")
      if saved_search_term.present?
      # response to the JSON
        render json: { success: true, response: saved_search_term.as_json },:status=>200
      else
        render :json=> { success: false, message: saved_search_term.errors },:status=> 203
      end
    end

    def recent_search_graph
      term = params[:term]
      @surgery_case = current_user.cases.where(:surgery_name => term)
      if @surgery_case.present?
        cases_dates_integer = @surgery_case.collect{|p| Time.parse(p.schedule.schedule_date.strftime("%d-%m-%Y")).to_i}.uniq
        cases_tags = @surgery_case.collect{|p| p.surgery_name}.uniq
        @tags_cases_count = cases_tags.collect{|p| {:name=>p, :data=>cases_dates_integer.collect{|q| @surgery_case.collect{|r| r if (r.surgery_name==p && Time.parse(r.schedule.schedule_date.strftime("%d-%m-%Y")).to_i==q) }.reject(&:blank?).count } }}
        @cases_dates = cases_dates_integer.collect{|p| Time.at(p).strftime("%d-%m-%Y")}
        render json: { success: true, response: {cases_dates:@cases_dates.as_json,cases_tags:cases_tags} },:status=>200
      else
        render json: { success: false, message: "Case is not available." },:status=>203
      end  
    end


    def saved_search_graph
      term = params[:term]
      @surgery_case = current_user.cases.where(:surgery_name => term)
      if @surgery_case.present?
        cases_dates_integer = @surgery_case.collect{|p| Time.parse(p.schedule.schedule_date.strftime("%d-%m-%Y")).to_i}.uniq
        cases_tags = @surgery_case.collect{|p| p.surgery_name}.uniq
        @tags_cases_count = cases_tags.collect{|p| {:name=>p, :data=>cases_dates_integer.collect{|q| @surgery_case.collect{|r| r if (r.surgery_name==p && Time.parse(r.schedule.schedule_date.strftime("%d-%m-%Y")).to_i==q) }.reject(&:blank?).count } }}
        @cases_dates = cases_dates_integer.collect{|p| Time.at(p).strftime("%d-%m-%Y")}
        render json: { success: true, response: {cases_dates:@cases_dates.as_json,cases_tags:cases_tags} },:status=>200
      else
        render json: { success: false, message: "Case is not available." },:status=>203
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
          cases_dates_integer = @surgery_case.collect{|p| Time.parse(p.schedule.schedule_date.strftime("%d-%m-%Y")).to_i}.uniq
          cases_tags = @surgery_case.collect{|p| p.surgery_name}.uniq
          @tags_cases_count = cases_tags.collect{|p| {:name=>p, :data=>cases_dates_integer.collect{|q| @surgery_case.collect{|r| r if (r.surgery_name==p && Time.parse(r.schedule.schedule_date.strftime("%d-%m-%Y")).to_i==q) }.reject(&:blank?).count } }}
          @cases_dates = cases_dates_integer.collect{|p| Time.at(p).strftime("%d-%m-%Y")}
          render json: { success: true, response: {cases_dates:@cases_dates.as_json,cases_tags:cases_tags} },:status=>200
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
    my_cases = @surgery_case.collect{|p| p if from_date <=p.schedule.schedule_date && p.schedule.schedule_date<=to_date}.reject(&:blank?)
    cases_dates_integer = my_cases.collect{|p| Time.parse(p.schedule.schedule_date.strftime("%d-%m-%Y")).to_i}.uniq
    cases_tags = my_cases.collect{|p| p.surgery_name}.uniq
    @tags_cases_count = cases_tags.collect{|p| {:name=>p, :data=>cases_dates_integer.collect{|q| my_cases.collect{|r| r if (q<=Time.parse(r.schedule.schedule_date.strftime("%d-%m-%Y")).to_i && Time.parse(r.schedule.schedule_date.strftime("%d-%m-%Y")).to_i<=q && r.surgery_name==p) }.reject(&:blank?).count } }}
    @cases_dates = cases_dates_integer.collect{|p| Time.at(p).strftime("%d-%m-%Y")}
   end

end
