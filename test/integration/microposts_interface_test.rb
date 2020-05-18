require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:taka)
  end
  
  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'  #ページネーション
    assert_select 'input[type=submit]'
    
    # 無効な送信
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: {content: ""}}
    end
    assert_select 'div#error_explanation'
    
    # 有効な送信
    content = "有効な投稿"
    image = fixture_file_upload('test/fixtures/kitten.jpg', 'image/jpeg')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content,
                                                   image: image}}
    end
    micropost = assigns(:micropost)
    assert micropost.image.attached?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    
    # 投稿を削除する
    assert_select 'a', text: '削除'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    
    # 異なるユーザーのプロフィールにアクセス(削除リンクがないことをテスト)
    get user_path(users(:archer))
    assert_select 'a', text: '削除', count: 0
  end
  
end
