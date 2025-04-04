class Api::V1::LikesController < ApplicationController
  before_action :require_login
  before_action :set_post

  def create
    if current_user.liking?(@post)
      render json: { error: 'すでにいいねしています' }, status: :unprocessable_entity
    else
      current_user.like!(@post)
      render :create, formats: :json, status: :created
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: '投稿が見つかりません' }, status: :not_found
  end

  def destroy
    like = current_user.likes.find_by(post: @post)

    if like
      like.destroy
      render :destroy, formats: :json, status: :ok
    else
      render json: { error: 'いいねしていません' }, status: :not_found
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end
end
