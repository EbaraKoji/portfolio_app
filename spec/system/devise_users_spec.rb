require 'rails_helper'

RSpec.describe "DeviseUser", type: :system, js: true do
  let! (:user) { create(:user) }
  before do
   user.confirm
  end
  scenario "sign up with valid params" do
    ActionMailer::Base.deliveries.clear
    visit root_path
    click_on "新規ユーザー登録"
    fill_in   "メールアドレス", with: "test1@example.org"
    fill_in   "パスワード", with: "password"
    fill_in   "パスワード(確認用)", with: "password"
    click_button "登録"
    expect(page).to have_content "本人確認用のメールを送信しました"
    expect(ActionMailer::Base.deliveries.size).to eq 1
  end

  scenario "sign up with invalid params" do
    ActionMailer::Base.deliveries.clear
    visit root_path
    click_on "新規ユーザー登録"
    fill_in   "メールアドレス", with: ""
    fill_in   "パスワード", with: "password"
    fill_in   "パスワード(確認用)", with: "password"
    click_button "登録"
    expect(page).to have_content "メールアドレス が入力されていません"
    expect(ActionMailer::Base.deliveries.size).to eq 0
  end

  scenario "get #index" do
    visit users_path
    expect(page).to have_content "@example.com"
  end

  scenario "get #show" do
    visit user_path user.id
    expect(page).to have_content "@example.com"
  end

  scenario "edit profile" do
    def edit_profile(user)
      visit edit_user_registration_path user.id
      fill_in   "メールアドレス", with: "edited@example.com"
      fill_in   "新しいパスワード", with: "new_password"
      fill_in   "新しいパスワード(確認用)", with: "new_password"
      fill_in   "現在のパスワード", with: user.password
      click_button "更新"
    end

    ActionMailer::Base.deliveries.clear
    sign_in user
    edit_profile(user)
    expect(page).to have_content "アカウント情報を変更しました。変更されたメールアドレスの本人確認のため、本人確認用メールより確認処理をおこなってください。"
    expect(user.reload.email).to_not eq "edited@example.com"
    expect(ActionMailer::Base.deliveries.size).to eq 1
    # パスワード変更後は同じパスワードでプロフィール変更はできない
    ActionMailer::Base.deliveries.clear
    edit_profile(user)
    expect(page).to have_content "エラーが発生したため ユーザ は保存されませんでした。"
    expect(ActionMailer::Base.deliveries.size).to eq 0
  end

  scenario "#reset password" do
    include EmailSpec::Helpers
    include EmailSpec::Matchers
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
    fill_in "新しいパスワード", with: "new_password"
    fill_in "新しいパスワード(確認用)", with: "new_password"
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
