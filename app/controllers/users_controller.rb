class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_uesr,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated?
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      # ユーザーモデルから、メールを送信
      @user.send_activation_email
      # メールの送信
      # UserMailer.account_activation(@user).deliver_now
      flash[:info] = "登録したメールアドレスにメールを送信しました。ご確認ください"
      redirect_to root_url
      # log_in @user
      # # flashメッセージを表示
      # flash[:success] = "ようこそ！todoListへ"
      # 保存成功時、users_path(@user)へリダイレクト
      # redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # 更新成功時
      flash[:success] = "編集しました。"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "削除しました。"
    redirect_to users_url
  end
  
  private
    # Strong Parameter permitで指定した属性以外、許可しない
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # application_controllerへ移行済み
    # def logged_in_user
    #   # ログインしていない場合
    #   unless logged_in?
    #     store_location
    #     flash[:danger] = "ログインしてください。"
    #     redirect_to login_url
    #   end
    # end
    
    def correct_uesr
      # ログインユーザーの取得
      @user = User.find(params[:id])
      # ログインユーザーとcurrent_userが異なる場合、rootへ遷移
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # ユーザー削除を実行するユーザーに管理者権限があるか
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end
