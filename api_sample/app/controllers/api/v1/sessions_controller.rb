class Api::V1::SessionsController < ApplicationController
  def create
    @user = User.find_by(name: params[:name])
    if @user&.authenticate(params[:password])
      session[:user_id] = @user.id
      render :create, status: :ok
    else
      render json: { error: 'ログインに失敗しました' }, status: :unauthorized
    end
  end

  def me
    if current_user
      @user = current_user
      render :me, status: :ok
    else
      render json: { error: 'ログインしていません' }, status: :unauthorized
    end
  end

  def destroy
    session.delete(:user_id)
    render json: { message: 'ログアウトしました' }, status: :ok
  end
end
