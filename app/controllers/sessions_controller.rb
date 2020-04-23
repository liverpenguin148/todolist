class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # log_inメソッドで一時セッションを作成
      log_in user
      # rememberメソッドでハッシュ化した記憶トークンをDBに保存
      remember user
      #ユーザーログイン後にユーザー情報へリダイレクト
      redirect_to user
    else
      #エラーメッセージ表示
      flash.now[:danger] = "メールアドレス、またはパスワードに誤りがあります。"
      render 'new'
    end
  end
  
  def destroy
    log_out
    redirect_to root_url
  end
end
