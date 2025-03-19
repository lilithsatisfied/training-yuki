require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

    assert_template 'users/edit'
    assert_select 'div.alert', text: "The form contains 4 errors."
  end

  test "successful edit with friendly forwarding only on first login" do
    # 1回目のログイン: フレンドリーフォワーディングが機能する
    get edit_user_path(@user)
    assert_not session[:forwarding_url].nil?  # forwarding_urlがセットされていることを確認
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)  # フレンドリーフォワーディングが機能していることを確認
    assert session[:forwarding_url].nil?  # forwarding_urlはクリアされるべき

    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email

    # 2回目のログイン: フレンドリーフォワーディングが機能しない（デフォルトのページへリダイレクト）
    delete logout_path  # ログアウト
    log_in_as(@user)    # 再ログイン
    assert_redirected_to @user  # フレンドリーフォワーディングは適用されず、プロフィール画面へ
  end
end
