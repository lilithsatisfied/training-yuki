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

  def show
    post = Post.find(params[:id])
    render json: {
      id: post.id,
      content: post.content,
      user_name: post.user.name
    }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: '投稿が見つかりません' }, status: :not_found
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
