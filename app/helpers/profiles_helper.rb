module ProfilesHelper
	def user_image user
	  if user.try(:profile_setting).try(:profile_image).try(:thumb).try(:url).nil?
	    image_tag 'default-user.png'
	  else
	  	image_tag user.profile_setting.profile_image.thumb.url
	  end
	end

	def profile_cover_image profile_setting
		if profile_setting.try(:cover_image).try(:url).nil?
			image_tag 'avascular-necrosis-hip-surgery-banner.jpg'
		else
			image_tag @profile_setting.cover_image.url
		end
	end

	def profile_photo profile_setting
		if profile_setting.try(:profile_image).try(:url).nil?
			image_tag 'default-user.png'
		else
			image_tag @profile_setting.profile_image.url
		end
	end

end
