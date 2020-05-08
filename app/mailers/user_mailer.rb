class UserMailer < ApplicationMailer

  # アカウントの有効化リンクをもつメールを送信
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "アカウントの有効化"
    # ⇒ return: mail object(text/html)
    #   example: mail.deliver
  end

  # パスワード再設定用リンクを持つメールを送信
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "パスワード再設定"
  end
end
