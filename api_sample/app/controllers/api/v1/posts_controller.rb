class Api::V1::PostsController < ApplicationController
  before_action :require_login

  def index
    @posts = Post.includes(:user).order(created_at: :desc)
    render :index, formats: :json
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      render :create, formats: :json, status: :created
    else
      render json: { error: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
