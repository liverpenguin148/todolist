module SessionsHelper
  # 渡されたユーザーでログイン
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # ユーザーのセッションを永続的にする
  def remember(user)
    # 記憶トークンをハッシュ化し、DBに保存
    user.remember
    # user_idとremember_tokenをcookiesに保存
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # 永続セッションの破棄
  def forget(user)
    # DBにある記憶ダイジェストを破棄
    user.forget
    # cookies情報の破棄
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # 現在のユーザー情報を取得
  def current_user
    if (user_id = session[:user_id])
      # 一時セッションが存在する場合
      @current_user ||= User.find_by(id: session[:user_id])
    elsif (user_id = cookies.signed[:user_id])
      # 一時セッションが無かった場合
      user = User.find_by(id: user_id)
      if user && user.authenticate?(cookies[:remember_token])
        log_in(user)
        @current_user = user
      end
    end
  end
  
  # 渡されたユーザーがログイン済みユーザーなら、Trueを返す
  def correct_user?(user)
      user == current_user
  end
  
  # ユーザーがログインしていればtrue, その他ならfalse
  def logged_in?
    current_user
  end
  
  # ログアウト セッション破棄 + @current_userをnil
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  # 記憶したURL（もしくはデフォルト値）へリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  
  # アクセスしようとしたURLをセッションへ保存
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
