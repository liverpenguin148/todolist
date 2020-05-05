class UserMailer < ApplicationMailer

  # アカウントの有効化リンクをもつメールを送信
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "アカウントの有効化"
    # ⇒ return: mail object(text/html)
    #   example: mail.deliver
  end

  #
  def password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end