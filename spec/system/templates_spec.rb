require 'rails_helper'

RSpec.describe 'テンプレート', type: :system, js: true do
  let!(:user) { FactoryBot.create(:user) }
  let!(:template) { FactoryBot.create(:template, user_id: user.id) }

  before do
    sign_in_as user
  end

  it 'テンプレートを作成する' do
    click_on'つぶやき投稿', match: :first
    click_on 'テンプレートを作成する'
    fill_in 'template[content]', with: 'サンプル'
    expect do
      click_on '登録する'
      expect(page).to have_css '.template_items', visible: false
    end.to change { Template.count }.by(1)
  end

  it 'テンプレートを削除する' do
    visit templates_path
    expect do
      find('.template_delete', match: :first).click
      page.driver.browser.switch_to.alert.text == 'テンプレートを削除しますか?'
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_css '.template_items', visible: false
    end.to change { Template.count }.by(-1)
  end

  it 'テンプレートをつぶやきに挿入する' do
    click_on'つぶやき投稿', match: :first
    click_on 'テンプレートを使う'
    click_on 'つぶやきテンプレート'
    expect(page).to have_text 'つぶやきテンプレート'
    expect do 
      click_on '投稿する'
      expect(page).to have_css '.post_name', visible: false
    end.to change { Micropost.count }.by(1)
  end
end
