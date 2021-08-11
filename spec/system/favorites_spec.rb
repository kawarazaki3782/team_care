require 'rails_helper'

RSpec.describe 'お気に入り', type: :system, js: true do
  let!(:user) { FactoryBot.create(:user) }
  let!(:micropost) { FactoryBot.create(:micropost, user_id: user.id) }
  let!(:diary) { FactoryBot.create(:diary, user_id: user.id) }

  before do
    sign_in_as user
  end

  it 'つぶやきをお気に入りに登録する' do
    click_on '自分のつぶやき'
    click_on 'つぶやきサンプル'
    expect do
      find('.btn_base_favorites').click
      expect(page).to have_css '.btn_base_favorites', visible: false
    end.to change { Favorite.count }.by(1)
  end

  describe 'つぶやきのお気に入りを解除する' do
    let!(:favorite) { FactoryBot.create(:favorite, user_id: user.id, micropost_id: micropost.id) }
    it 'つぶやきのお気に入りを解除する' do
      click_on '自分のつぶやき'
      click_on 'つぶやきサンプル'
      expect do
        find('.btn_base_favorites').click
        expect(page).to have_css '.btn_base_favorites', visible: false
      end.to change { Favorite.count }.by(-1)
    end
  end

  it '日記をお気に入りに登録する' do
    click_on '自分の日記'
    click_on 'タイトル'
    expect do
      find('.btn_base_favorites').click
      expect(page).to have_css '.btn_base_favorites', visible: false
    end.to change { Favorite.count }.by(1)
  end

  describe '日記のお気に入りを解除する' do
    let!(:favorite) { FactoryBot.create(:favorite, user_id: user.id, diary_id: diary.id) }
    
    it 'つぶやきのお気に入りを解除する' do
      click_on '自分の日記'
      click_on 'タイトル'
      expect do
        find('.btn_base_favorites').click
        expect(page).to have_css '.btn_base_favorites', visible: false
      end.to change { Favorite.count }.by(-1)
    end
  end

  describe '例外処理' do
    let!(:other_user) { FactoryBot.create(:user, name: 'その他ユーザー') }
    let!(:other_micropost) { FactoryBot.create(:micropost, user_id: other_user.id, content: 'つぶやきサンプル2') }
    let!(:other_diary) { FactoryBot.create(:diary, user_id: other_user.id, title: 'タイトルサンプル')}
    
    it 'つぶやきをお気に入りに登録する直前でユーザーが削除' do
      find('a.btn_base_users', match: :first).click
      click_on 'その他ユーザー'
      click_on 'つぶやきサンプル2'
      find(".section-title_post", text: "つぶやき詳細")
      User.find_by(name: 'その他ユーザー').destroy
      find('.btn_base_favorites').click
      expect(page).to have_text 'つぶやきが削除されました'
    end

    it 'つぶやきをお気に入りから解除する直前でユーザーが削除' do
      find('a.btn_base_users', match: :first).click
      click_on 'その他ユーザー'
      click_on 'つぶやきサンプル2'
      find(".section-title_post", text: "つぶやき詳細")
      find('.btn_base_favorites').click
      User.find_by(name: 'その他ユーザー').destroy
      find('.btn_base_favorites').click
      expect(page).to have_text 'つぶやきが削除されました'
    end

    it '日記をお気に入りに登録する直前でユーザーが削除' do
      find('a.btn_base_users', match: :first).click
      click_on 'その他ユーザー'
      click_on 'タイトルサンプル'
      find(".section-title_diary", text: "日記詳細")
      User.find_by(name: 'その他ユーザー').destroy
      find('.btn_base_favorites').click
      expect(page).to have_text '日記が削除されました'
    end

    it '日記をお気に入りから解除する直前でユーザーが削除' do
      find('a.btn_base_users', match: :first).click
      click_on 'その他ユーザー'
      click_on 'タイトルサンプル'
      find(".section-title_diary", text: "日記詳細")
      find('.btn_base_favorites').click
      User.find_by(name: 'その他ユーザー').destroy
      find('.btn_base_favorites').click
      expect(page).to have_text '日記が削除されました'
    end
  end
end
