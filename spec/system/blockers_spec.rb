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

    it 'ブロックできない場合' do
      find('a.btn_base_users', match: :first).click
      click_on 'その他ユーザー'
      User.find_by(name: 'その他ユーザー').destroy
      find('.follow_block_item', match: :first, visible: false).click
      expect(flash[:alert]).to eq 'ブロックできません'
    end
  end
end
