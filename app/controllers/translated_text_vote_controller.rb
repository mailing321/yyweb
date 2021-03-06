class TranslatedTextVoteController < ApplicationController

  def create
    
    return unless check_user;
    
    tt = TranslatedText.find_by_id(params[:id].to_i)
    if tt.nil?
      return render :text => 'error'
    end
    tt.transaction do
      TranslatedTextVote.create(
        :user => curr_user,
        :translated_text => tt,
        :create_at => Time.now
      )
      tt.paragraph.refresh_choosed
    end
    
    NotificationMessage.notify(tt.author, curr_user, tt, NotificationMessage::TypeVote)
    
    render :text => 'ok'
  end
  
  def destroy
    return unless check_user
    
    vote = TranslatedTextVote.find_by_id(params[:id].to_i)
    if vote.nil?
      return render :text => 'error'
    elsif vote.user_id != curr_user.id
      return render :text => 'error'
    end
    vote.transaction do
      vote.destroy
      vote.translated_text.paragraph.refresh_choosed
    end
    render :text => 'ok'
  end
  
  private
  
  def check_user
    if curr_user.nil?
      render :text => 'error'
      return false
    elsif curr_user.ban?
      render :text => 'error'
      return false
    end
    return true
  end
end
