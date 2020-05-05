class AccountActivationsController < ApplicationController
  
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticate?(:activation, params[:id])
      user.update_attribute(:activated,    true)
      user.update_attribute(:activated_at, Time.zone.now)
      log_in user
      flash[:success] = "アカウントを有効化しました。"
      redirect_to user
    else
      flash[:danger] = "アカウントが有効化できません。再度リンクを確認してください。"
      redirect_to root_url
    end
  end
end
