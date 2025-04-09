# app/controllers/api/v1/comments_controller.rb
class Api::V1::CommentsController < ApplicationController
  before_action :require_login
  before_action :set_post

  def create
    @post = Post.find(params[:id])
    @comment = current_user.comment_on(@post, params[:comment][:content])

    render :create, formats: :json, status: :created
  rescue ActiveRecord::RecordNotFound
    render json: { error: '投稿が見つかりません' }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def set_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: '投稿が見つかりません' }, status: :not_found
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
