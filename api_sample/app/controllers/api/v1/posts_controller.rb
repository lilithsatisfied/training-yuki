class Api::V1::PostsController < ApplicationController
  before_action :require_login

  def index
    posts = Post.includes(:user).order(created_at: :desc)
    render json: posts.as_json(only: [:id, :content], include: { user: { only: :name } })
  end

  def create
    post = current_user.posts.build(post_params)
    if post.save
      render json: { message: '投稿を作成しました', post: post }, status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

    def post_params
      params.require(:post).permit(:content)
    end
end