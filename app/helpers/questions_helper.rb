module QuestionsHelper
	def owned_user_like(likedModel, user)
    	likedModel.votes.where(:user_id=>user.id).first
  	end
end



