class PasswordResetsController < ApplicationController
  before_action :get_user,         only: [:edit, :update]
  before_action :valid_user,       only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end
  
  def create
    @user = User.find_by(email: params[:password_reset][:email])
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "パスワード再設定のリンクを入力したメールアドレスへ送信しました。ご確認ください。"
      redirect_to root_url      
    else
      flash[:danger] = "入力したメールアドレスは会員登録されていません。ご確認の上、再度入力をしてください。"
      render 'new'
    end
  end

  def edit
  end
  
  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "パスワードを再設定しました。"
      @user.update_attributes(reset_digest: nil)
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  private
    # Strong Parameter
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    
    # メールアドレスから、ユーザーを検索
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    # パスワードの再設定を行うユーザーが正しいかどうか確認する
    def valid_user
      unless (@user && @user.activated? && @user.authenticate?(:reset, params[:id]))
        redirect_to root_url
      end
    end
    
    # パスワード再設定の有効期限が切れているかチェック
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "パスワード再設定の有効期限が切れています。"
        redirect_to new_password_reset_url
      end
    end
end
