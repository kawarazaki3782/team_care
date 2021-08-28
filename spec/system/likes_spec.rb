require 'rails_helper'

RSpec.describe 'いいね', type: :system, js: true do
  let!(:user) { FactoryBot.create(:user) }
  let!(:micropost) { FactoryBot.create(:micropost, user_id: user.id) }
  let!(:diary) { FactoryBot.create(:diary, user_id: user.id) }

  before do
    sign_in_as user
  end

  it 'つぶやきにいいねをする' do
    click_on '自分のつぶやき'
    expect do
      find('.likes_unliked', match: :first, visible: false).click
      expect(page).to have_css '.likes_liked', visible: false
    end.to change { Like.count }.by(1)
  end

  it 'つぶやきのいいねを取り消す' do
    visit root_path
    find('.likes_unliked', match: :first, visible: false).click
    expect do
      find('.likes_liked', match: :first, visible: false).click
      expect(page).to have_css '.likes_unliked', visible: false
    end.to change { Like.count }.by(-1)
  end

  it '日記にいいねをする' do
    visit root_path
    expect do
      find('.likes_unliked_diary', match: :first, visible: false).click
      expect(page).to have_css '.likes_liked_diary', visible: false
    end.to change { Like.count }.by(1)
  end

  it '日記のいいねを取り消す' do
    visit root_path
    find('.likes_unliked_diary', match: :first, visible: false).click
    expect do
      find('.likes_liked_diary', match: :first, visible: false).click
      expect(page).to have_css '.likes_unliked_diary', visible: false
    end.to change { Like.count }.by(-1)
  end

  describe "例外処理" do
    let!(:other_user) { FactoryBot.create(:user, name: 'その他ユーザー') }
    let!(:other_micropost) { FactoryBot.create(:micropost, user_id: other_user.id, content: 'つぶやきサンプル2') }
    let!(:other_diary) { FactoryBot.create(:diary, user_id: other_user.id, title: 'タイトルサンプル')}
    
    it 'つぶやきにいいねする直前でユーザーが削除' do
      find('a.btn_base_users', match: :first).click
      click_on 'その他ユーザー'
      click_on 'つぶやきサンプル2'
      find(".section-title_post", text: "つぶやき詳細")
      User.find_by(name: 'その他ユーザー').destroy
      find('.likes_unliked').click
      expect(page).to have_text 'つぶやきが削除されました'
    end

    it '日記にいいねする直前でユーザーが削除' do
      find('a.btn_base_users', match: :first).click
      click_on 'その他ユーザー'
      click_on 'タイトルサンプル'
      find(".section-title_diary", text: "日記詳細")
      User.find_by(name: 'その他ユーザー').destroy
      find('.likes_unliked_diary').click
      expect(page).to have_text '日記が削除されました'
    end
  end
end
