require 'rails_helper'

RSpec.describe '問い合わせ', type: :system,js: true do
  it '問い合わせができること'do
    visit root_path
    click_on 'お問い合わせ', match: :first
    fill_in "inquiry[name]",with: "サンプル太郎"
    fill_in "inquiry[email]",with: "sample@gmail.com"
    fill_in "inquiry[message]",with: "サンプル"
    click_on '送信する'
    expect(page).to have_content 'お問い合わせ内容の確認'
    click_on '送信する'
    expect(page).to have_content 'お問い合わせいただきありがとうございました。'
  end
end