class CaseSerializer < BaseSerializer
  #list of json attributes
  attributes :id, :diagnose_name, :surgery_name, :schedule_date, :assistant_name,:user_form_data,:user_form_fields,:patient_id, :user_id
end