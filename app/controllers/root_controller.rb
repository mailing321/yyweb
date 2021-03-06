class RootController < ApplicationController

  def show
    @posts = []
    limit = 12
    num = limit
    num = pick_up(num, limit, HomePagePost.posts)
    num = pick_up(num, limit, Post.where(:is_delete => false).order('last_reply_at desc'))
    
    @left_posts = @posts[0..5]
    @right_posts = @posts[6..11]
    
    @left_posts = [] if @left_posts.nil?
    @right_posts = [] if @right_posts.nil?
    
    @line_posts = []
    for i in 0..5
      if @left_posts[i].nil? and @right_posts[i].nil?
        break
      end
      @line_posts << [@left_posts[i], @right_posts[i]]
    end
    render :'root/root'
  end
  
  private
  
  def pick_up(num, limit, where)
    return if num <= 0
    list = where.limit(limit + @posts.length)
    list = list.reject do |p|
      @posts.include?(p)
    end
    num -= list.length
    list.each do |p|
      @posts << p
    end
    return num
  end
  
end
