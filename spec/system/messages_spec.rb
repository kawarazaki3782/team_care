require 'rails_helper'

RSpec.describe 'DM機能', type: :system, js: true do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:user,name: 'その他ユーザー',email: 'sample@gmail.com') }
    
  before do
    sign_in_as user
  end
  
  describe 'DM機能が使えること' do
    it 'メッセージを送る' do
      find('a.btn_base_users',match: :first).click
      click_on "その他ユーザー"
      expect do  
        click_on 'お手紙を送る'
        fill_in 'message[content]', with:'こんにちは'
        click_on '投稿する'
        expect(page).to have_css '.btn-sm.btn-danger.dm_delete', visible: false
      end.to change { Message.count }.by(1)
    end

    it 'メッセージを削除する' do
        find('a.btn_base_users',match: :first).click
        click_on "その他ユーザー"  
        click_on 'お手紙を送る'
        fill_in 'message[content]', with:'こんにちは'
        click_on '投稿する'
        find('.btn-sm.btn-danger.dm_delete',match: :first).click
        page.driver.browser.switch_to.alert.text == 'コメントを削除しますか?'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'またメッセージはありません'
    end
  end
end