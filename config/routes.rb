Rails.application.routes.draw do
  
  devise_for :users , :controllers => { sessions: 'sessions',registrations: 'registrations'}
  resources :patients

  namespace :api do    
    # post "/sign_up", :to => 'registrations#create'
    # post "/sign_in", :to => 'sessions#create'
    devise_for :users
    as :user do 
      post "/sign_in/step_2", :to => 'sessions#verify_number'
    end    
   
    resources :contents,:only=>[] do
      post :about, on: :collection
      post :faq, on: :collection
      post :contact, on: :collection
    end
    resources :profiles,:only=>[:create,:update,:show] do 
      get :user_profile_data, on: :collection
      post :update_address, on: :collection
      post :update_high_school, on: :collection
      post :update_medical_school, on: :collection
      post :update_residency_diploma, on: :collection
      post :update_spe_training, on: :collection
      post :update_award, on: :collection
      post :update_passcode, on: :collection
      post :update_my_hobbies, on: :collection
      post :update_my_favorites, on: :collection
      post :update_my_quote, on: :collection
      post :update_about_me, on: :collection
      get :surgery_name_list,on: :collection
      get :diagnosis_name_list,on: :collection
      post :update_work_phone, on: :collection
      post :update_home_phone, on: :collection
      post :update_profile_photo,on: :collection
      post :update_specialist,on: :collection
      get :user_app_data, on: :collection
    end

    resources :users do
      resources :user_passcodes, :except=>[:destroy, :index], :controller => "passcodes"
      post "match_passcode",:to => 'passcodes#match_passcode'
    end
    
    resources :patients do
      get :search_patients, on: :member
      resources :cases,:except=>[:index]
    end
    
    resources :manage_assistants,:except=>[:new,:edit]

    resources :question_advance_search,:only=>[:index,:create] do
      post :search_questions, on: :collection
      get :show_recent_search, on: :collection
      delete :destory_search_term, on: :collection
      get :show_saved_search, on: :collection
      post :complex_question_search, on: :collection
      get :advance_search_graph,on: :collection

    end
    
    resources :media,:only=>[:index] do
      post :media_search, on: :collection
      post :sort_search_media, on: :collection
      post :group_search_media, on: :collection
    end

    resources :cases do
      resources :case_media, :only=>[:index,:create,:update,:destroy] do
      end
      resources :case_notes, :except=>[:index,:destroy] 
    end

    resources :schedules, :only=>[:index] 

    resources :case_media_attachments, :only=>[:show,:update,:destroy] do
      post :search_tags, on: :collection
      put :attachment_update, on: :member
    end

    resources :specialities, :only=>[:index] do
      post :specialist_search, on: :collection
    end  

    resources :surgeries, :only=>[:index] do
      post :surgery_search, on: :collection
    end
    resources :surgery_locations , :only=>[:create,:update,:index] 
    resources :helps,:only=>[:create] 
    
    resources :user_forms, :only=>[] do
      post :create_field, on: :collection
    end

    resources :questions do 
      get :my_scn, on: :collection 
      get :my_scn_answers, on: :collection
      get :scn_users, on: :collection 
      get :most_answers_questions, on: :collection
      get :most_votes_questions, on: :collection 
      post :single_tag_questions, on: :collection  
      post :search_tags, on: :collection
      delete :destroy_question_media, on: :member  
      resources :answers, :only=>[:create], :controller => "answers"
      resources :votes , :only=>[:create,:destroy] 
    end
    resources :answers, :only=>[:create] do
      resources :votes, :only=>[] do
        post   :create_answer_votes, on: :collection   
        delete :destroy_answer_votes, on: :member
      end
    end
    resources :search, :only=>[] do
      post :create, on: :collection 
      post :case_search, on: :collection 
      post :sort_search_cases, on: :collection 
      get :show_recent_search, on: :collection
      get :show_saved_search, on: :collection
      post :complex_case_search, on: :collection 
      delete :destory_search_term, on: :collection 
    end
    
    resources :settings,:only=>[] do 
      post :set_session_time,on: :collection
      post :set_media_upload_limit,on: :collection
      post :set_media_tag,on: :collection
      post :set_scn_tag,on: :collection
      post :set_app_color,on: :collection
      get :about,on: :collection
      get :help,on: :collection
      post :user_send_feedback,on: :collection
      post :user_send_report,on: :collection
    end

    resources :associates,:except=>[:new,:update]  do
      get :accept, on: :member
      get :reject, on: :member
      post :search_user, on: :collection
      post :create_invitation,on: :collection
      get :user_invitations,on: :collection
      get :show_user_detail,on: :collection
      post :update_edit_right,on: :member
      get :associate_users, on: :collection
      get :start_associate_session, on: :collection
    end

    # Creating Resource For Admin Module
    resources :admin,:only=>[] do 
      get :check_user,on: :member
      get :show_form_template, on: :collection 
      get :show_form_field, on: :collection 
    end

    resources :graphs,:only=>[] do 
      post :date_range,on: :collection
      post :quick_stats,on: :collection
      post :tags_date_range,on: :collection
      post :show_cases, on: :collection
      post :date_line_chart,on: :collection
      post :quick_stats_line_chart,on: :collection
    end

    resources :graph_advance_search,:only=>[:index,:create] do
      post :destory_search_term, on: :collection
      get :show_saved_search, on: :collection
      post :complex_graph_search, on: :collection
      get :show_recent_search, on: :collection
      get :show_recent_search, on: :collection
      post :recent_search_graph, on: :collection
      post :saved_search_graph, on: :collection
    end
  end  

  root to: 'patients#index'

  resources :patients do 
    resources :cases, :controller => "patients/cases" 
  end
  
  resources :schedules do
    get :add, on: :collection
    get :search_patients, on: :collection
    get :schedule_view, on: :collection
    get :list_view, on: :collection
    get :search_diagnose,on: :collection
    get :search_surgery,on: :collection
  end

  resources :surgery_locations 

  resources :cases do
    get :new_case_template,on: :member
    get :new_user_case_template,on: :collection
    get :edit_case_surgery,on: :member
    resources :case_media, :controller => "cases/case_media" do
      get :share_timeline,on: :collection
      resources :case_media_attachments 
    end
    resources :case_notes, :controller => "cases/case_notes"
  end

  resources :user_forms do
      get :new_field, on: :collection
      post  :create_field,on: :collection
      get :new_user_form, on: :collection
      post :create_user_form,on: :collection
  end
    
  resources :case_media_attachments do 
    get :search_tags, on: :collection
    put :attachment_update,on: :member
    get :attachment_destroy,on: :member
  end


  resources :search do
    get :case_search, on: :collection
    get :sort_search_cases, on: :collection
    get :destory_search_term, on: :collection
    get :create_recent_search, on: :collection
    get :advance_search, on: :collection
    get :show_recent_search, on: :collection
    get :show_saved_search, on: :collection
    get :show_complex_search, on: :collection
    get :complex_case_search, on: :collection
  end

  # resource for the question and answer modal
  resources :questions do 
    get :my_scn, on: :collection
    get :my_scn_answers, on: :collection
    get :post, on: :member
    get :most_answers_questions, on: :collection
    get :most_votes_questions, on: :collection
    get :scn_users, on: :collection
    get :question_list, on: :collection
    get :search_tags,on: :collection
    get :show_question_tags, on: :member
    get :show_filter_options, on: :collection
    delete :destroy_question_media, on: :member
    resources :votes do
      post   :create_question_votes, on: :collection   
      delete :destroy_question_votes, on: :member
    end
  end

  resources :question_advance_search do
    get :search_questions, on: :collection
    get :destory_search_term, on: :collection
    get :create_recent_search, on: :collection
    get :show_recent_search, on: :collection
    get :show_saved_search, on: :collection
    get :complex_question_search, on: :collection
  end

  resources :answers do
    resources :votes do
      post   :create_answer_votes, on: :collection   
      delete :destroy_answer_votes, on: :member
    end
  end

  resources :answers

  resources :settings do 
    get :session_timeout,on: :collection
    get :check_session_time,on: :collection
    get :tag_setting,on: :collection
    get :media_upload_setting,on: :collection
    get :media_upload_limit,on: :collection
    get :set_media_upload_limit,on: :collection
    get :passcodes_setting,on: :collection
    get :color_palette_setting,on: :collection
    get :set_app_color,on: :collection
    get :show_help_video,on: :collection
    get :show_about,on: :collection
    get :legal_privacy,on: :collection
    get :report_issue,on: :collection
    get :send_feedback,on: :collection
    get :user_send_feedback,on: :collection
    get :set_tag_limit,on: :collection
    get :user_send_report,on: :collection
  end


  resources :media,:only=>[:index] do
    get :media_search, on: :collection
    get :sort_search_media, on: :collection
    get :group_search_media, on: :collection
  end

  resources :media_advance_search,:only=>[:index,:create] do
    get :destory_search_term, on: :collection
    get :create_recent_search, on: :collection
    get :show_recent_search, on: :collection
    get :show_saved_search, on: :collection
    get :complex_media_search, on: :collection
  end

  resources :case_media_attachments

  resources :profiles do
    get :user_profile_data, on: :member
    get :user_app_data, on: :member
    get :user_address, on: :collection
    post :update_address, on: :member
    get :high_school, on: :collection
    post :update_high_school, on: :member
    get :medical_school, on: :collection
    post :update_medical_school, on: :member
    get :residency_diploma, on: :collection
    post :update_residency_diploma, on: :member
    get :spe_training, on: :collection
    post :update_spe_training, on: :member
    get :award, on: :collection
    post :update_award, on: :member
    get :my_hobbies, on: :collection
    get :my_favorites, on: :collection
    get :my_quote, on: :collection
    get :about_me, on: :collection
    get :user_work_phone, on: :collection
    get :user_home_phone, on: :collection
    post :update_phone, on: :member
    get :surgery_name_list,on: :collection
    get :profile_photo,on: :collection
    post :update_profile_photo,on: :member
    get :diagnosis_name_list,on: :collection
    get :profile_setting_list,on: :member
    get :specialist_setting,on: :collection
    post :update_specialist,on: :member
    get :profile_specialist_search,on: :collection
    post :update_profile_setting,on: :member
    get :show_user_profile,on: :collection
    get :edit_surgery_name, on: :member
    post :update_surgery_name, on: :member
    get :edit_diagnose_name, on: :member
    post :update_diagnose_name, on: :member
  end

  resources :associates do
    get :add, on: :collection
    get :accept, on: :member
    get :reject, on: :member
    get :search_user, on: :collection
    post :create_invitation,on: :collection
    get :user_invitations,on: :collection
    get :show_user_detail,on: :collection
    get :update_edit_right,on: :member
    get :associate_users, on: :collection
    get :set_edit_right, on: :collection
  end
  # Creating Resource For Admin Module
  resources :admin,:only=>[:index] do 
    get :dashboard,on: :collection
    get :search_user,on: :collection
    get :manage_user,on: :collection
    get :user_status,on: :member
    get :user_profile,on: :member
    get :reset_password,on: :member
    get :password_update,on: :member
  end

  resources :admin_forms,:only=>[:index] do
    get   :new_field,on: :collection
    post  :create_field,on: :collection
    get   :new_form,on: :collection
    post  :create_form,on: :collection
    get   :edit_field,on: :member
    put   :update_field,on: :member
    delete :destroy_field,on: :member
    get   :edit_form,on: :member
    put   :update_form,on: :member
    delete :destroy_form,on: :member
  end
  
  resources :specialities do
    get :specialist_search, on: :collection
    resources :specs
  end  

  resources :surgeries do
    get :surgery_search, on: :collection
  end
  resources :diagnoses do 
    get :diagnose_search, on: :collection
  end

  resources :tag_settings do 
    get :media_tag,on: :collection
    get :set_media_tag,on: :collection
    get :scn_tag,on: :collection
    get :set_scn_tag,on: :collection
  end

  resources :manage_assistants do 
    post :create_assistants,on: :member 
    get :edit_assistants,on: :member
    
    get  :anaesthetists,on: :collection
    post :create_anaesthetists,on: :member
    get :anaesthetists_list,on: :collection
  end


  resources :graphs do 
    get :date_range,on: :collection
    get :quick_stats,on: :collection
    get :tags_date_range,on: :collection
    get :date_line_chart,on: :collection
    get :date_bar_chart,on: :collection
    get :quick_stats_line_chart,on: :collection
    get :quick_stats_bar_chart,on: :collection
    get :show_cases, on: :collection
    get :search_diagnose_and_surgery, on: :collection
  end

  resources :graph_advance_search,:only=>[:index,:create] do
    get :destory_search_term, on: :collection
    get :create_recent_search, on: :collection
    get :show_recent_search, on: :collection
    get :show_saved_search, on: :collection
    get :complex_graph_search, on: :collection
    get :advance_search_graph,on: :collection
  end
  
  resources :helps
  resources :contents

  resources :subscribers,:only=>[:new,:create,:update] 


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
