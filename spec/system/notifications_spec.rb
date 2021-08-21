require 'rails_helper'

RSpec.describe '通知機能', type: :system, js: true do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:user, name: 'その他ユーザー') }
  let!(:micropost) { FactoryBot.create(:micropost, user_id: user.id) }
  let!(:diary) { FactoryBot.create(:diary, user_id: user.id) }

  before do
    sign_in_as other_user
  end

  it 'フォローされた通知を確認する' do
    find('a.btn_base_users', match: :first).click
    click_on 'サンプル太郎'
    find('.follow_item_btn', match: :first).click
    click_on 'ログアウト', match: :first
    sign_in_as user
    click_on '通知', match: :first
    expect(page).to have_css '.notification_image', visible: false
  end

  it 'いいねされた通知を確認する' do
    find('a.btn_base_users', match: :first).click
    click_on 'サンプル太郎'
    find('.likes_unliked', match: :first, visible: false).click
    click_on 'ログアウト', match: :first
    sign_in_as user
    click_on '通知', match: :first
    expect(page).to have_css '.notification_image', visible: false
  end

  it 'コメントされた通知を確認する' do
    find('a.btn_base_users', match: :first).click
    click_on 'サンプル太郎'
    click_on 'つぶやきサンプル'
    find('.section-title_post', match: :first)
    fill_in 'comment[content]', with: 'サンプル'
    click_on 'コメントする'
    click_on 'ログアウト', match: :first
    sign_in_as user
    click_on '通知', match: :first
    expect(page).to have_css '.notification_image', visible: false
  end

  it '助けを求めた通知を確認する' do
    find('a.btn_base_users', match: :first).click
    click_on 'サンプル太郎'
    click_on '助けを求める'
    click_on 'ログアウト', match: :first
    sign_in_as user
    click_on '通知', match: :first
    expect(page).to have_css '.notification_image', visible: false
  end

  describe '通知を削除する' do
    let!(:like) { FactoryBot.create(:like, user_id: other_user.id, micropost_id: micropost.id) }
    let!(:notification) do
      FactoryBot.create(:notification, visiter_id: other_user.id, visited_id: user.id, micropost_id: micropost.id,
                                       action: 'micropost_like')
    end
    it '通知を削除' do
      click_on '通知', match: :first
      click_on 'すべての通知を削除する'
      page.driver.browser.switch_to.alert.text == 'すべての通知を削除しますか?'
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_content '通知はありません'
    end
  end
end
