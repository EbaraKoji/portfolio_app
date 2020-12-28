require 'rails_helper'

RSpec.describe "DeviseUser", type: :system, js: true do
  let! (:user) { create(:user) }
  before do
   user.confirm
  end
  signup_email = "signup@example.com"
  signup_name = "test user"
  signup_password = "password"
  new_email = "edited@example.com"
  new_name = "edited user"
  new_pwd = "new_password"

  scenario "sign up with valid params" do
    ActionMailer::Base.deliveries.clear
    visit root_path
    click_on "新規ユーザー登録"
    fill_in   "メールアドレス", with: signup_email
    fill_in   "ユーザー名", with: signup_name
    fill_in   "パスワード", with: signup_password
    fill_in   "パスワード(確認用)", with: signup_password
    click_button "登録"
    expect(page).to have_content "本人確認用のメールを送信しました"
    expect(ActionMailer::Base.deliveries.size).to eq 1
    new_user = User.last
    expect(new_user.email).to eq signup_email
    expect(new_user.confirmed?).to be_falsy

    #メール認証
    mail = open_email(signup_email)
    click_email_link_matching(/^http:/, mail)
    expect(page).to have_content "メールアドレスが確認できました。"
    expect(new_user.reload.confirmed?).to be_truthy
  end

  scenario "User cannot sign up with invalid email address" do
    ActionMailer::Base.deliveries.clear
    visit root_path
    click_on "新規ユーザー登録"
    fill_in   "メールアドレス", with: ""
    fill_in   "ユーザー名", with: signup_name
    fill_in   "パスワード", with: signup_password
    fill_in   "パスワード(確認用)", with: signup_password
    click_button "登録"
    expect(page).to have_content "メールアドレス が入力されていません"
    expect(ActionMailer::Base.deliveries.size).to eq 0
  end

  scenario "User cannot sign up with invalid password" do
    ActionMailer::Base.deliveries.clear
    visit root_path
    click_on "新規ユーザー登録"
    fill_in   "メールアドレス", with: signup_email
    fill_in   "ユーザー名", with: signup_name
    fill_in   "パスワード", with: ""
    fill_in   "パスワード(確認用)", with: ""
    click_button "登録"
    expect(page).to have_content "パスワード が入力されていません"
    expect(ActionMailer::Base.deliveries.size).to eq 0
  end

  scenario "get #index" do
    visit users_path
    expect(page).to have_content "Username"
  end

  scenario "get #show" do
    visit user_path user.id
    expect(page).to have_content user.name
  end

  scenario "edit profile" do
    #メールアドレスとパスワードを変更
    ActionMailer::Base.deliveries.clear
    sign_in user
    visit edit_user_registration_path user.id
    fill_in   "メールアドレス", with: new_email
    fill_in   "ユーザー名", with: new_name
    fill_in   "新しいパスワード", with: new_pwd
    fill_in   "新しいパスワード(確認用)", with: new_pwd
    fill_in   "現在のパスワード", with: user.password
    click_button "更新"
    expect(page).to have_content "アカウント情報を変更しました。変更されたメールアドレスの本人確認のため、本人確認用メールより確認処理をおこなってください。"
    expect(user.reload.email).to_not eq new_email
    expect(ActionMailer::Base.deliveries.size).to eq 1

    #メール認証
    mail = open_email(new_email)
    click_email_link_matching(/^http:/, mail)
    expect(page).to have_content "メールアドレスが確認できました。"
    expect(user.reload.email).to eq new_email

    #変更したパスワードで再度ログイン
    click_on "ログアウト"
    expect(page).to have_content "新規ユーザー登録"
    click_on "ログイン"
    expect(page).to have_content "次回から自動的にログイン"
    fill_in   "メールアドレス", with: new_email
    fill_in   "パスワード", with: new_pwd
    click_button "ログイン"
    expect(page).to have_content "ログインしました。"
  end

  scenario "#reset password" do
    ActionMailer::Base.deliveries.clear

    visit new_user_session_path
    expect(page).to have_content "次回から自動的にログイン"
    click_on "パスワードを忘れましたか?"
    fill_in "メールアドレス", with: user.email
    click_on "送信"
    expect(page).to have_content "パスワードの再設定について数分以内にメールでご連絡いたします。"
    expect(ActionMailer::Base.deliveries.size).to eq 1
    mail = open_email(user.email)
    click_email_link_matching(/^http:/, mail)
    expect(page).to have_content "パスワードを変更する"
    fill_in "新しいパスワード", with: new_pwd
    fill_in "新しいパスワード(確認用)", with: new_pwd
    click_button "変更"
    expect(page).to have_content "パスワードが正しく変更されました。"
  end


  scenario "delete account" do
    sign_in user
    visit edit_user_registration_path user.id
    expect {
      page.accept_confirm do
        find('#delete_account').click
      end
      expect(page).to have_content "アカウントを削除しました。"
    }.to change(User, :count).by(-1)
  end
end
