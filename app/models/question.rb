class Question
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::TagsArentHard
  # scope added for listing the questions with most answers
  scope :most_answers_questions, ->{ order_by(:answers_count => :desc) }
  scope :most_votes_questions, ->{ order_by(:votes_count => :desc) }
  taggable_with :tags

  field :title, type: String
  field :content, type: String
  field :answers_count, type: Integer, default: 0
  field :votes_count, type: Integer, default: 0

  belongs_to :user

  has_many :answers,dependent: :destroy
  has_many :options,dependent: :destroy

  has_many :question_media_attachments
  
  has_many :votes, as: :voteable ,dependent: :destroy

  accepts_nested_attributes_for :question_media_attachments
  accepts_nested_attributes_for :options, allow_destroy: true


  def as_json(type, options={})
    data =  
    case type
      when 'question_data'
      {
       :surgeon => self.user.name,
       :created_time => self.created_at.strftime("%B  %d, %Y"),
       :answers_count => self.answers_count,
       :votes_count => self.votes_count,
       :scn_count => self.user.scn_score,
       :tags => self.tags
     }
     when 'my_scn_answers' 
      {
      :created_time => self.created_at.strftime("%B  %d, %Y"),
      :answers_count => self.answers_count,
      :answers => self.answers.collect(&:answer_text)
      }
     when 'my_scn' 
      {
      :answers_count => self.answers_count,
      :votes_count => self.votes_count
      }
     when 'question_show' 
      {
      :title => self.title,
      :surgeon => self.user.name,
      :created_time => self.created_at.strftime("%B  %d, %Y"),
      :answers_count => self.answers_count,
      :options => self.options.collect(&:text),
      :poll_count => self.answers.where(:poll=>self.options.first.text).count,
      :answers => self.answers
      }
    when 'question_update' 
      {
      :content => self.content,
      :tags => self.tags,
      :options => self.options.collect{|x| x if x.question_id!=nil}.compact,
      :question_media_attachments => self.question_media_attachments.collect{|x| x if x.question_id!=nil}.compact
    }
    end.merge({
      :id => self.id,
      :title => self.title,
      :user_profile => self.user.setting.profile.profile_image
    })
    data
  end

  def vote_present?(user)
    !votes.where(:user_id =>user.id).first.blank?
  end

  def vote_not_present?(user)
    votes.where(:user_id =>user.id).first.blank?
  end

end