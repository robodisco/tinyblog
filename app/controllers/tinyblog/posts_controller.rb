require_dependency "tinyblog/application_controller"

module Tinyblog
  class PostsController < ApplicationController
    
    before_action :load_post, only: :show
    before_action :authorize_post, only: :show
    before_action :redirect_old_slugs, only: :show

    respond_to :html, :rss

    def index
      @posts = Post.with_published_state.latest.includes(:author).all
      @latest_posts = Post.with_published_state.latest.limit(Tinyblog.max_latest_posts).all if Tinyblog.latest_posts_on
      respond_with @posts
    end

    def show
      @post.view! unless tinyblog_admin_logged_in?

      @author = @post.author
      @latest_posts = Post.with_published_state.latest.limit(Tinyblog.max_latest_posts).all if Tinyblog.latest_posts_on

      respond_with @post
    end

    private

    def load_post
      @post = Post.find(params[:id])
    end

    def authorize_post
      if tinyblog_admin_logged_in? or
        @post.published? or
        @post.access_key == params[:access_key]
        return true
      else
        raise ActiveRecord::RecordNotFound
      end
    end

    # If post slug has chnaged due to title change then 
    # need to redirect any requests to the old slug names
    # to the current one.
    def redirect_old_slugs
      if request.path != post_path(@post)
        redirect_to(post_path(@post), :status => :moved_permanently) and return
      end
    end
  end
end
