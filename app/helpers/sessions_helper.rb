module SessionsHelper
  # 渡されたユーザーでログイン
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # 現在のユーザー情報を取得
  def current_user
    if session[:user_id]
      if @current_user.nil?
        @current_user = User.find_by(id: session[:user_id])
      else
        @current_user
      end
    end
  end
  
  # ユーザーがログインしていればtrue, その他ならfalse
  def logged_in?
    current_user
  end
end
