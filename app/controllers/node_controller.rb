class NodeController < ApplicationController

  def show
    @node = Node.find_by_id(params[:id].to_i)
    raise ActionController::RoutingError.new('Node Not Found') unless @node
    
    if params[:path_name] and @node.path_name != params[:path_name]
      raise ActionController::RoutingError.new('Node Not Found')
    end
    page = params[:page].to_i
    page = (page==0)?1:page
    @posts = @node.posts_list.page(page).per_page(Node::PerPage)
    @page_title = @node.name
    
    render :'node/posts_list'
  end
  
end
