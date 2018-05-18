class PostsController < ApplicationController
  before_action :set_feed, only: :index

  def index
    @posts = @feed.posts.order('published desc')
  end

  def show
    @post = Post.find(params[:id])
  end

  private
  def set_feed
    @feed = Feed.find(params[:id])
  end
end
