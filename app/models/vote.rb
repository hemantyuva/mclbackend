class Vote
  include Mongoid::Document
  belongs_to :user
  belongs_to :voteable , polymorphic: :true

  after_create :increase_vote_count ,:increase_scn_score 
  after_destroy :decrease_vote_count, :decrease_scn_score

  #method for increase the user votes count
  def increase_vote_count
  	count = voteable.votes_count
  	count = count + 1
  	voteable.update_attributes(votes_count: count)
  end

  #method for decrease the user votes count
  def decrease_vote_count
  	count = voteable.votes_count
  	count = count - 1
  	voteable.update_attributes(votes_count: count)
  end

  #method for increase the user scn_score
  def increase_scn_score
    count = voteable.user.scn_score
    count = count + 1
    voteable.user.update_attributes(scn_score: count)
  end

  #method for decrease the user scn_score
  def decrease_scn_score
    count = voteable.user.scn_score
    count = count - 1
    voteable.user.update_attributes(scn_score: count)
  end

end