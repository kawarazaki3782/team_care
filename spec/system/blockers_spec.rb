require 'rails_helper'

RSpec.describe 'ブロック機能', type: :system, js: true do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:user, name: 'その他ユーザー', email: 'sample@gmail.com') }

  before do
    sign_in_as user
  end

  describe 'ユーザーをブロックする' do
    it 'ブロックできること' do
      find('a.btn_base_users', match: :first).click
      click_on 'その他ユーザー'
      expect do
        find('.follow_block_item', match: :first).click
        expect(page).to have_css '.follow_block_item', visible: false
      end.to change { Block.count }.by(1)
    end

    it 'ブロックを解除できること' do
      find('a.btn_base_users', match: :first).click
      click_on 'その他ユーザー'
      find('.follow_block_item', match: :first).click
      expect do
        find('.follow_block_item', match: :first).click
        expect(page).to have_css '.follow_block_item', visible: false
      end.to change { Block.count }.by(-1)
    end

    it 'ブロックをする途中でユーザーが削除された場合' do
      find('a.btn_base_users', match: :first).click
      click_on 'その他ユーザー'
      find("div.user_name_users", text: "その他ユーザーさん")
      other_user.delete
      find('.follow_block_item', match: :first, visible: false).click
      expect(page).to have_text 'ユーザーが削除されました'
    end

    it 'ブロックを解除する途中でユーザーが削除された場合' do
      find('a.btn_base_users', match: :first).click
      click_on 'その他ユーザー'
      find('.follow_block_item', match: :first, visible: false).click
      find("div.user_name_users", text: "その他ユーザーさん")
      User.find_by(email: 'sample@gmail.com').destroy
      find('.follow_block_item', match: :first, visible: false).click
      expect(page).to have_text 'ユーザーが削除されました'
    end
  end
end
