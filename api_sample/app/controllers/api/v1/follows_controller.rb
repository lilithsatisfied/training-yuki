class Api::V1::FollowsController < ApplicationController
  before_action :require_login

  def create
    @followee = User.find(params[:id])

    if current_user.following?(@followee)
      render json: { error: 'すでにフォローしています' }, status: :unprocessable_entity
    else
      current_user.follow!(@followee)
      render :create, status: :created # ← jbuilder を使う
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'ユーザーが見つかりません' }, status: :not_found
  end

  def destroy
    @followee = User.find(params[:id])
    follow = current_user.active_follows.find_by(followee: @followee)

    if follow
      follow.destroy
      render :destroy, status: :ok # ← jbuilder を使う
    else
      render json: { error: 'フォローしていません' }, status: :not_found
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'ユーザーが見つかりません' }, status: :not_found
  end
end
