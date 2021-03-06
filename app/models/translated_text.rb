class TranslatedText < ActiveRecord::Base

  belongs_to :author, :foreign_key => :author_id, :class_name => "User"
  belongs_to :paragraph, :counter_cache => :translated_text_count
  
  has_many :translated_text_vote, :dependent => :destroy
  
  def vote_id_by(user)
    return nil if user.nil?
    vote = TranslatedTextVote.where(:translated_text_id => self.id, :user_id => user.id).first
    if vote.nil?
      return nil
    else
      return vote.id
    end
  end
  
end
