namespace :user do
  desc "TODO"
  task update_owner: :environment do
  	Patient.each do |patient|
  		patient.owner_id = patient.user_id
  		patient.save
  	end
  	Case.each do |case_data|
  		case_data.owner_id = case_data.user_id  		
  		case_data.save
  	end
  	CaseMedium.each do |case_medium|
  		case_medium.owner_id = case_medium.user_id	
  		case_medium.save
  	end
  	CaseNote.each do |case_note|
  		case_note.owner_id = case_note.user_id	
  		case_note.save
  	end
  end

  task update_surgery_date: :environment do
    Case.each do |case_data|
      case_data.surgery_date = case_data.schedule_date      
      case_data.save
    end
  end

end
