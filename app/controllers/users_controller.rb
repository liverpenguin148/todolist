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
end
