module CaseMediumHelper
	# Method for cheching the attachement size limit
	def check_size_attachment case_media
			if current_user.setting.media_upload.try(:media_upload_limit)
				size_limit = current_user.setting.media_upload.media_upload_limit.to_i
				# collecting all the case media of case media attachments
				attachment_size = case_media.case_media_attachments.collect{|attachement| attachement.attachment.size <= size_limit*1024*1024}
			end
	end
end
