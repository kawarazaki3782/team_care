require "rails_helper"

RSpec.describe"ユーザー登録機能", type: :system,js: true do
  include LoginSupport
  let!(:user) { FactoryBot.create(:user, name: "一般ユーザー") }
  let!(:other_user) { FactoryBot.create(:user, name: "その他ユーザー") }
  let!(:admin_user) { FactoryBot.create(:user, admin: true) }

  describe "新規登録" do
    it "新しいユーザーを作成できること" do
      visit root_path
      click_link "新規登録", match: :first

      attach_file "user[profile_image]", "spec/fixtures/noimage.jpeg"
      fill_in "user[name]", with: "サブロー"
      fill_in "user[email]", with: "sample@example.com"
      fill_in "user[password]", with: "password"
      fill_in "user[password_confirmation]", with: "password"
      select '男性', from: 'user[gender]'
      select '1989', from: 'user[birthday(1i)]'
      select '1', from: 'user[birthday(2i)]'
      select '2', from: 'user[birthday(3i)]'
      select '静岡県', from: 'user[address]'
      select '介護者', from: 'user[long_teamcare]'
      fill_in "user[profile]", with: "こんにちは"
      click_on "確認画面へ"

      expect(page).to have_content "登録内容の確認"
    end
  end

  describe '編集機能' do
    it 'プロフィールを編集出来ること' do
      sign_in_as(user)
      click_link 'プロフィール編集'

      attach_file "user[profile_image]", "spec/fixtures/noimage.jpeg"
      fill_in "user[name]", with: "サブロー"
      fill_in "user[email]", with: "sample@example.com"
      fill_in "user[password]", with: "password"
      fill_in "user[password_confirmation]", with: "password"
      select '男性', from: 'user[gender]'
      select '1989', from: 'user[birthday(1i)]'
      select '1', from: 'user[birthday(2i)]'
      select '2', from: 'user[birthday(3i)]'
      select '静岡県', from: 'user[address]'
      select '介護者', from: 'user[long_teamcare]'
      fill_in "user[profile]", with: "こんにちは"
      click_on '確認画面へ'
      expect(page).to have_content '編集内容の確認'
      
    end

    it '他のユーザーの編集ページにはアクセスできないこと' do
      sign_in_as(user)
      visit edit_user_path(other_user)
      expect(page).not_to have_current_path edit_user_path(other_user)
      expect(page).to have_current_path root_path
    end
 end
end
