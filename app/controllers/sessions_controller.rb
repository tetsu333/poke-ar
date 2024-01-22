class SessionsController < ApplicationController
  before_action :logged_in?, only: [:new, :create]

  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to pokemons_path, notice: "こんにちは。#{@user.name}さん"
    else
      redirect_to new_sessions_path, alert: "ログインに失敗しました。"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_sessions_path
  end

  private

  def logged_in?
    if session[:user_id]
      @user = User.find(session[:user_id])
      redirect_to pokemons_path, notice: "すでにログインしています。"
    end
  end
end
