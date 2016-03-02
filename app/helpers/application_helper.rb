module ApplicationHelper

	# Showing the Date Format in the Profile Show Page
	def user_created_at(date)
		date.strftime("%b %Y")
	end

	# Showing the Total No of SCNS for that Particular Profile User
	def total_scns user
		ques_count = user.questions.count
		ans_count = user.answers.count
		total_count = ques_count + ans_count
	end

	# Showing the Total No of Questions for that Particular Profile User
	def total_questions user
		ques_count = user.questions.count
	end

	# Showing the Total No of Answers for that Particular Profile User
	def total_answers user
		ans_count = user.answers.count
	end

	# Counting the all the Entries of the particular case
	def case_entries_count(surgery_case)
		total_notes = surgery_case.case_notes.count
		total_media = surgery_case.case_media.count
		total_entries =  total_notes + total_media
	end

	# Find the Particular Case Note For particular Case
	def find_case_note(case_note)
		@case_note = CaseNote.find(case_note)
	end

	# Find the Particular Case media For particular Case
	def find_case_media(case_media)
		@case_media = CaseMedium.find(case_media)
	end

	# Find the Particular Case Media Attachment For particular Case
	def find_case_media_attachment(attachment)
		@attachment = CaseMediaAttachment.find(attachment)
	end

	# Find the Surgeon name for that particular case
	def find_case_user(user_id,owner_id)
		if user_id == owner_id
			@user = User.find(user_id)
			@user_name = @user.name.upcase
		else
			@user = User.find(owner_id)
			@user_name = @user.name.upcase
		end
	end

	def surgery_counts_text(count)
		count>1 ? "Surgeries" : "Surgery"
	end

	def schedule_dates(date)
		date.strftime("%B %d, %Y").upcase
	end
	
	def attachment_format(date)
		date.strftime("%B %d, %Y")
	end


	def patient_dob(dob)
		TimeDifference.between(Date.today,dob).in_years.to_i
	end

	def schedule_week(week)
		week.strftime("%A").upcase
	end

	def schedule_month(month)
		month.strftime("%b")
	end

	def schedule_date(date)
		date.strftime("%d")
	end

	def schedule_hour(hour)
		hour.strftime("%I")
	end

	def schedule_min(min)
		min.strftime("%M")
	end

	def schedule_notation(time_notation)
		time_notation.strftime("%p")
	end

	def surgery_time(time)
		time.strftime("%I:%M")
	end

	def surgery_notation(time_notation)
		time_notation.strftime("%p").downcase
	end

	def schedule_date_format(date)
		date.strftime("%d-%m-%Y %I:%M %p") 
	end

	def case_datum_format(date)
		date.strftime("%b %d, %Y").upcase
	end

	def schedule_days(date)
		TimeDifference.between(Date.today,date).in_days.to_i
	end

	def schedule_date_compare datetime
		@schedule_date = datetime.to_date
	end

end
