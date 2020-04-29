class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_uesr,   only: [:edit, :update]
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      # flashメッセージを表示
      flash[:success] = "ようこそ！todoListへ"
      # 保存成功時、users_path(@user)へリダイレクト
      redirect_to @user
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
  
  private
    # Strong Parameter permitで指定した属性以外、許可しない
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    def logged_in_user
      # ログインしていない場合
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
    
    def correct_uesr
      # ログインユーザーの取得
      @user = User.find(params[:id])
      # ログインユーザーとcurrent_userが異なる場合、rootへ遷移
      redirect_to(root_url) unless correct_user?(@user)
    end
end
