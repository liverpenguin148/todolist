class UsersController < ApplicationController
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
  
  private
    # Strong Parameter permitで指定した属性以外、許可しない
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
