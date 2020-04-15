require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    # 名前を空文字にする
    @user.name = " "
    # ユーザーが登録されない
    assert_not @user.valid?
  end
  
  test "email should be present" do
    # メールアドレスを空文字にする
    @user.email = " "
    # ユーザーが登録されない
    assert_not @user.valid?
  end
end
