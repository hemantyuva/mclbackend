# class TagSettingsController < ApplicationController
# 	# before action need to find the setting
# 	before_action :setting

# 	# Method for the initialize the setting with media attachment tags
# 	def media_tag
# 		# Initialize the media tags setting
# 			@media_tag_setting = setting.build_media_tag
# 	end

# 	# Method for creating ther media tag for setting the limit
# 	def set_media_tag
# 		# Creating the limitation for the media attachment tags
# 		@media_tag_limit = setting.build_media_tag(tag_data_media_tag)
# 		# creating the media tags limit
# 		@media_tag_limit.save
# 		# redirect to the tags setting page
# 		redirect_to tag_setting_settings_path
# 	end

# 	# Method for the initialize the setting with scn question tags
# 	def scn_tag
# 		# Initialize the scn question tags setting
# 		@scn_tag_setting = setting.build_scn_tag
# 	end

# 	# Method for creating ther question tag for setting the limit
# 	def set_scn_tag
# 		# Creating the limitation for the question tags
# 		@scn_tag_limit = setting.build_scn_tag(scn_data_media_tag)
# 		# creating the question tags limit
# 		@scn_tag_limit.save
# 		# redirect to the tags setting page
# 		redirect_to tag_setting_settings_path
# 	end


# 	private

# 	# Permitting the media tag params
# 	def tag_data_media_tag
# 		params.require(:tag_data_media_tag).permit(:media_tag_limit)
# 	end

# 	# Permitting the question tag params
# 	def scn_data_media_tag
# 		params.require(:tag_data_scn_tag).permit(:scn_tag_limit)
# 	end

# 	def setting
# 		# Condition for checking the setting exits for surgeon
# 		if current_user.setting.blank?
# 			#Initialize setting for surgeon
# 			setting = current_user.build_setting
# 			# Saving setting information for surgeon
# 			setting.save
# 		else
# 			#Fetch setting information for surgeon
# 			setting = current_user.setting
# 		end
# 	end

# end
