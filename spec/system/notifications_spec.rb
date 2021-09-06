require 'rails_helper'

RSpec.describe '通知機能', type: :system, js: true do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:user, name: 'その他ユーザー') }
  let!(:micropost) { FactoryBot.create(:micropost, user_id: user.id) }
  let!(:diary) { FactoryBot.create(:diary, user_id: user.id) }
  
  describe '通知の確認' do
    before do
      sign_in_as other_user
    end

    it 'フォローされた通知を確認する' do
      click_on 'マイページ', match: :first
      find('a.btn_base_users', match: :first).click
      click_on 'サンプル太郎', match: :first
      find('.follow_item_btn', match: :first).click
      click_on 'ログアウト', match: :first
      sign_in_as user
      click_on '通知', match: :first
      expect(page).to have_css '.notification_image', visible: false
    end

    it 'いいねされた通知を確認する' do
      click_on 'マイページ', match: :first
      find('a.btn_base_users', match: :first).click
      click_on 'サンプル太郎', match: :first
      find('.likes_unliked', match: :first, visible: false).click
      click_on 'ログアウト', match: :first
      sign_in_as user
      click_on '通知', match: :first
      expect(page).to have_css '.notification_image', visible: false
    end

    it 'コメントされた通知を確認する' do
      click_on 'マイページ', match: :first
      find('a.btn_base_users', match: :first).click
      click_on 'サンプル太郎', match: :first
      click_on 'つぶやきサンプル'
      find('.section-title_post', match: :first)
      find('input[type="textarea"]').set('サンプル')
      click_on 'コメントする'
      page.accept_confirm
      click_on 'ログアウト', match: :first
      sign_in_as user
      click_on '通知', match: :first
      expect(page).to have_css '.notification_image', visible: false
    end
      
    it 'DM通知を確認する' do
      click_on 'マイページ', match: :first
      find('a.btn_base_users', match: :first).click
      click_on 'サンプル太郎', match: :first
      click_on 'お手紙を送る'
      fill_in 'message[content]', with: 'サンプル'
      click_on '投稿する'
      click_on 'ログアウト', match: :first
      sign_in_as user
      click_on '通知', match: :first
      expect(page).to have_css '.notification_image', visible: false
    end
  end
    
  describe '助けを求めた通知の確認'do
    before do
      sign_in_as user
    end

    it '助けを求めた通知の確認' do
      click_on 'マイページ', match: :first
      click_on '助けを求める'
      page.driver.browser.switch_to.alert.text == '全利用者に通知を送付しますか？'
      page.driver.browser.switch_to.alert.accept
      click_on 'ログアウト', match: :first
      sign_in_as other_user
      click_on '通知', match: :first
      expect(page).to have_css '.notification_image', visible: false
    end
  end

  describe '通知を削除する' do
    let!(:like) { FactoryBot.create(:like, user_id: other_user.id, micropost_id: micropost.id) }
    let!(:notification) do
      FactoryBot.create(:notification, visiter_id: other_user.id, visited_id: user.id, micropost_id: micropost.id,
                                       action: 'micropost_like')
    end
    
    it '通知を削除' do
      sign_in_as other_user
      click_on '通知', match: :first
      click_on 'すべての通知を削除する'
      page.driver.browser.switch_to.alert.text == 'すべての通知を削除しますか?'
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_content '通知はありません'
    end
  end
end