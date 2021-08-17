require 'rails_helper'

RSpec.describe '日記投稿', type: :system, js: true do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:user, name: 'その他ユーザー') }

  describe '新規作成' do
    it '日記投稿できること' do
      sign_in_as user
      visit new_diary_path
      fill_in 'diary[title]', with: 'タイトル'
      fill_in 'diary[content]', with: 'コンテンツ'
      attach_file 'diary[diary_image]', 'spec/fixtures/noimage.jpeg'
      click_on '投稿する'
      expect(page).to have_current_path diaries_path
    end
  end

  describe '日記一覧表示' do
    before do
      FactoryBot.create(:diary, user_id: user.id)
      sign_in_as user
    end

    it '自分の日記一覧が表示されること' do
      visit diaries_path
      expect(page).to have_content '日記一覧'
    end

    it 'お気に入りの日記一覧が表示されること' do
      visit user_path(user)
      click_on 'お気に入り'
      expect(page).to have_content 'お気に入りの日記'
    end

    it 'フォローした利用者の日記一覧が表示されること' do
      visit root_path
      expect(page).to have_content 'フォローしている人の日記'
    end

    it 'みんなの日記一覧が表示されること' do
      visit root_path
      expect(page).to have_content 'みんなの最新の日記'
    end

    it '自分の下書き一覧が表示されること' do
      visit diaries_path
      click_on '下書きフォルダへ'
      expect(page).to have_content '下書きフォルダ'
    end
  end

  describe '日記詳細表示' do
    before do
      FactoryBot.create(:diary, user_id: user.id)
      sign_in_as user
    end
    it '日記詳細' do
      visit diaries_path
      click_on 'タイトル'
      expect(page).to have_content '日記詳細'
    end
  end

  describe '下書き詳細表示' do
    before do
      FactoryBot.create(:diary, user_id: user.id, status: 0)
      sign_in_as user
    end
    it '下書き詳細' do
      visit diaries_path
      click_on '下書きフォルダへ'
      click_on 'タイトル'
      expect(page).to have_content '日記詳細'
    end
  end

  describe '日記編集' do
    before do
      FactoryBot.create(:diary, user_id: user.id)
      sign_in_as user
    end

    it '日記の編集' do
      visit diaries_path
      click_on 'タイトル'
      click_on '日記を編集'
      fill_in 'diary[title]', with: 'タイトル'
      fill_in 'diary[content]', with: 'コンテンツ'
      attach_file 'diary[diary_image]', 'spec/fixtures/noimage.jpeg'
      click_on '更新する'
      expect(page).to have_current_path diaries_path
    end
  end

  describe '下書き編集' do
    before do
      FactoryBot.create(:diary, user_id: user.id, status: 0)
      sign_in_as user
    end

    it '下書きの編集' do
      visit diaries_path
      click_on '下書きフォルダへ'
      click_on 'タイトル'
      click_on '日記を編集'
      fill_in 'diary[title]', with: 'タイトル'
      fill_in 'diary[content]', with: 'コンテンツ'
      attach_file 'diary[diary_image]', 'spec/fixtures/noimage.jpeg'
      select '公開する', from: 'diary[status]'
      click_on '更新する'
      expect(page).to have_current_path diaries_path
    end
  end

  describe '日記削除' do
    before do
      FactoryBot.create(:diary, user_id: user.id)
      sign_in_as user
    end

    it '日記を削除できること(日記詳細)' do
      visit diaries_path
      click_on 'タイトル'
      page.accept_confirm do
        click_on '日記を削除'
      end
      visit diaries_path
      expect(page).to have_content '日記一覧'
    end
  end

  describe '下書き削除' do
    before do
      FactoryBot.create(:diary, user_id: user.id, status: 0)
      sign_in_as user
    end

    it '下書きの削除' do
      visit diaries_path
      click_on '下書きフォルダへ'
      click_on 'タイトル'
      page.accept_confirm do
        click_on '削除'
      end
      visit diaries_path
      expect(page).to have_content '日記一覧'
    end
  end

  describe "例外処理" do
    let!(:other_diary) { FactoryBot.create(:diary, user_id: other_user.id, title: 'タイトルサンプル') }

    before do
      sign_in_as user
    end

    it '日記詳細を開く直前でユーザーが削除された場合' do
      find('a.btn_base_users', match: :first).click
      click_on 'その他ユーザー'
      find("div.user_name_users", text: "その他ユーザーさん")
      User.find_by(name: 'その他ユーザー').destroy
      click_on 'タイトルサンプル'
      expect(page).to have_text '日記が削除されました'
    end
  end
end