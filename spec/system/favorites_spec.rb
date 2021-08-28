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
    click_on 'お気に入り'
    expect(page).to have_content 'お気に入り解除'
  end

  describe 'つぶやきのお気に入りを解除する' do
    let!(:favorite) { FactoryBot.create(:favorite, user_id: user.id, micropost_id: micropost.id) }
    it 'つぶやきのお気に入りを解除する' do
      click_on '自分のつぶやき'
      click_on 'つぶやきサンプル'
      click_on 'お気に入り解除'
      expect(page).to have_content 'お気に入り'
    end
  end

  it '日記をお気に入りに登録する' do
    click_on '自分の日記'
    click_on 'タイトル'
    click_on 'お気に入り', match: :first
    expect(page).to have_content 'お気に入り解除'
  end

  describe '日記のお気に入りを解除する' do
    let!(:favorite) { FactoryBot.create(:favorite, user_id: user.id, diary_id: diary.id) }
    
    it '日記のお気に入りを解除する' do
      click_on '自分の日記'
      click_on 'タイトル'
      click_on 'お気に入り解除'
      expect(page).to have_content 'お気に入り'
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
      accept_alert("お気入りの登録に失敗しました")do
        click_on 'お気に入り'
        expect(page).not_to have_text('お気に入り解除')
      end
    end

    it '日記をお気に入りに登録する直前でユーザーが削除' do
      find('a.btn_base_users', match: :first).click
      click_on 'その他ユーザー'
      click_on 'タイトルサンプル'
      find(".section-title_diary", text: "日記詳細")
      User.find_by(name: 'その他ユーザー').destroy
      accept_alert("お気入りの登録に失敗しました")do
        click_on 'お気に入り'
        expect(page).not_to have_text('お気に入り解除')
      end
    end
  end
end
