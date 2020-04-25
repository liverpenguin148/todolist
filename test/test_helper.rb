ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

# models/user_test.rbで使用するヘルパー
class ActiveSupport::TestCase
  fixtures :all
  
  # テストユーザーがログイン中の場合、trueを返す
  def is_logged_in?
    !session[:user_id].nil?
  end
  
  # テストユーザーとしてログインする
  def log_in_as(user)
    session[:user_id] = user.id
  end
end

# integration以下のテストで使用するヘルパー
class ActionDispatch::IntegrationTest
  # テストユーザーとしてログイン
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: {email: user.email,
                                         password: password,
                                         remember_me: remember_me } }
  end
end