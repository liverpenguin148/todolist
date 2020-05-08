class PasswordResetsController < ApplicationController
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
end
