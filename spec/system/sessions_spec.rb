require 'rails_helper'

describe 'セッション機能', type: :system, js: true do
  before do
    FactoryBot.create(:user, email: 'sample@gmail.com', password: 'password')
  end

  it '登録済みユーザーがログインとログアウトできること' do
    visit login_path
    fill_in 'session[email]', with: 'sample@gmail.com'
    fill_in 'session[password]', with: 'password'
    expect(page).to have_button 'ログイン'
    click_button 'ログイン'
    expect(page).to have_content 'マイページ'
    click_on 'ログアウト',match: :first
    expect(page).to have_content 'チームケアへようこそ'
  end

  it '登録済みでないユーザーがログインできないこと' do
    visit login_path
    fill_in 'session[email]', with: 'sample@gmail.com'
    fill_in 'session[password]', with: 'dummy_password'
    click_button 'ログイン'
    expect(page).to have_content 'チームケアへようこそ'
  end

  it 'ゲストユーザーがログインとログアウトできること' do
    visit login_path
    click_on "簡単ログイン"
    expect(page).to have_content 'マイページ'
    click_on 'ログアウト',match: :first
    expect(page).to have_content 'チームケアへようこそ'
  end
end