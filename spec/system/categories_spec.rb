require 'rails_helper'

RSpec.describe 'カテゴリー', type: :system, js: true do
  let!(:user) { FactoryBot.create(:user) }
  let!(:micropost) { FactoryBot.create(:micropost, user_id: user.id) }
  let!(:diary) { FactoryBot.create(:diary, user_id: user.id) }
  let!(:category) { FactoryBot.create(:category, user_id: user.id) }

  before do
    sign_in_as user
  end

  it 'カテゴリーを作成する' do
    click_on 'カテゴリーの追加'
    click_on 'カテゴリーを追加する'
    fill_in 'category[name]', with: 'サンプル'
    expect do
      click_on '登録する'
      expect(page).to have_css '.category_items', visible: false
    end.to change { Category.count }.by(1)
  end

  it 'カテゴリーを削除する' do
    click_on 'カテゴリーの追加'
    expect do
      find('.categories_delete', match: :first).click
      page.driver.browser.switch_to.alert.text == 'カテゴリー削除しますか?'
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_css '.category_items', visible: false
    end.to change { Category.count }.by(-1)
  end
end
