class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # log_inメソッドで一時セッションを作成
      log_in user
      # チェックボックスの送信結果を処理
      # remember(user)：ハッシュ化した記憶トークンをDBに保存
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      #ユーザーログイン後にユーザー情報へリダイレクト
      redirect_back_or user
    else
      #エラーメッセージ表示
      flash.now[:danger] = "メールアドレス、またはパスワードに誤りがあります。"
      render 'new'
    end
  end
  
  def destroy
    # ログイン中のみ、ログアウトする
    log_out if logged_in?
    redirect_to root_url
  end
end
