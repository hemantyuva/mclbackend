class UserMailer < ApplicationMailer
	default from: "no-reply@mclbackend.in"

	def invitation(invitation,invite_url)
	    @invite_url = invite_url
	    @invitee = invitation.invitee.name
	    subject = "#{invitation.invitee.name} has invited you"
	    mail to: invitation.recipient_email, from: "no-reply@mclbackend.in", subject: subject
 	end

 	def feedback user,feedback
 		@user = user
 		@feedback = feedback
 		subject = "Feedback From #{@user.name}"
 		mail to: "mylarayuvasoft146@gmail.com", from: "#{@user.email}", subject: subject
 	end

 	def report_issue user,report
 		@user = user
 		@report = report
 		subject = "Report Issue From #{@user.name}"
 		mail to: "mylarayuvasoft146@gmail.com", from: "#{@user.email}", subject: subject
 	end
 	
end
