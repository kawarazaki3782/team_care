require 'rails_helper'

RSpec.describe 'フォロー機能', type: :system, js: true do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:user, name: 'その他ユーザー', email: 'sample@gmail.com') }

  before do
    sign_in_as user
  end

  describe 'ユーザーをフォローする' do
    it 'フォローできること' do
      find('a.btn_base_users', match: :first).click
      click_on 'その他ユーザー'
      expect do
        find('.follow_item_btn', match: :first).click
        expect(page).to have_css '.unfollow_item_btn', visible: false
      end.to change { Relationship.count }.by(1)
    end

    it 'フォローを解除できること' do
      find('a.btn_base_users', match: :first).click
      click_on 'その他ユーザー'
      find('.follow_item_btn', match: :first).click
      expect do
        find('.unfollow_item_btn', match: :first).click
        expect(page).to have_css '.follow_item_btn', visible: false
      end.to change { Relationship.count }.by(-1)
    end
  end

  describe "例外処理" do
    it 'フォローをする途中でユーザーが削除された場合' do
      find('a.btn_base_users', match: :first).click
      click_on 'その他ユーザー'
      find("div.user_name_users", text: "その他ユーザーさん")
      other_user.delete
      find('.follow_item_btn', match: :first, visible: false).click
      expect(page).to have_text 'ユーザーが削除されました'
    end

    it 'フォローを解除する途中でユーザーが削除された場合' do
      find('a.btn_base_users', match: :first).click
      click_on 'その他ユーザー'
      find('.follow_item_btn', match: :first, visible: false).click
      find("div.user_name_users", text: "その他ユーザーさん")
      User.find_by(email: 'sample@gmail.com').destroy
      find('.unfollow_item_btn', match: :first, visible: false).click
      expect(page).to have_text 'ユーザーが削除されました'
    end
  end
end

