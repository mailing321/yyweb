class TranslatedTextController < ApplicationController

  def create
    if not can_post?
      render :text => 'error'
      return
    end
    tt = TranslatedText.new
    tt.transaction do
      paragraph = Paragraph.find_by_id(params[:id].to_i, :lock => true)
      if paragraph.nil?
        render :text => 'error'
        return;
      end
      tt.paragraph = paragraph
      tt.author = curr_user
      tt.content = params[:content]
      tt.create_at = Time.now
      if not tt.save
        render :text => 'error'
        return
      end
      paragraph.refresh_choosed
      
      post = paragraph.post
      post.last_reply_user = curr_user
      post.last_reply_at = Time.now
      post.save
      
      NotificationLog.notify(post, curr_user, tt, NotificationMessage::TypeTranslate)
      
    end
    
    render :text => 'ok'
  end
  
  def update
    if not can_post?
      render :text => 'error'
      return
    end
    translated_text = TranslatedText.find_by_id(params[:id].to_i)
    if translated_text.nil?
      render :text => 'error'
      return
    end
    translated_text.content = params[:content]
    translated_text.save
    render :text => 'ok'
  end
  
  def destroy
    translated_text = TranslatedText.find_by_id(params[:id].to_i)
    if translated_text.nil?
      render :text => 'error'
      return
    end
    if not translated_text.paragraph.post.can_delete_by?(curr_user)
      render :text => 'error'
      return
    end
    translated_text.transaction do
      translated_text.destroy
      translated_text.paragraph.refresh_choosed
    end
    
    render :text => 'ok'
  end
  
end
