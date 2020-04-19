module SessionsHelper
  # 渡されたユーザーでログイン
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # 現在のユーザー情報を取得
  def current_user
    if session[:uesr_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
end
