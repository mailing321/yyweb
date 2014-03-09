class CommentPraise < ActiveRecord::Base

  belongs_to :user
  belongs_to :comment, :counter_cache => :praises_count
  
end
