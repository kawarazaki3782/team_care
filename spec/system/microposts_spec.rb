require 'rails_helper'

describe 'つぶやき投稿', type: :system, js: true do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user,name: 'その他ユーザー') }

  describe '新規作成' do
    it 'つぶやき投稿できること' do
      sign_in_as user
      visit new_micropost_path

      fill_in 'micropost[content]', with: 'コンテンツ'
      attach_file 'micropost[post_image]', 'spec/fixtures/noimage.jpeg'
      click_on '投稿する'

      expect(page).to have_current_path microposts_path
    end
  end

  describe 'つぶやき一覧表示' do
    before do
        FactoryBot.create(:micropost, user_id: user.id)
        sign_in_as user
    end

    it '自分のつぶやき一覧が表示されること' do
      visit microposts_path
      expect(page).to have_content 'つぶやき一覧'
    end
    
    it 'お気に入りのつぶやき一覧が表示されること' do
        visit user_path(user)
        click_on "お気に入りのつぶやき"
        expect(page).to have_content 'お気に入りのつぶやき'
    end

    it 'フォローした利用者のつぶやき一覧が表示されること' do
        visit root_path
        expect(page).to have_content 'フォローしている利用者のつぶやき'
    end
    
    it 'みんなのつぶやき一覧が表示されること' do
        visit root_path
        expect(page).to have_content 'みんなの最新のつぶやき'
    end
  end

  describe 'つぶやき詳細表示' do
    before do
        FactoryBot.create(:micropost, user_id: user.id)
        sign_in_as user
    end
    it 'つぶやき詳細' do
        visit microposts_path
        click_on 'つぶやきサンプル' 
        expect(page).to have_content 'つぶやき詳細'
    end
  end

  describe 'つぶやき削除' do
    before do
        FactoryBot.create(:micropost, user_id: user.id)
        sign_in_as user
    end

    it 'つぶやきを削除できること(つぶやき一覧)' do
      visit microposts_path
      page.accept_confirm do
        click_on 'つぶやき削除'
      end

      visit microposts_path
      expect(page).to have_content 'つぶやき一覧'
    end

    it 'つぶやきを削除できること(つぶやき詳細)' do
        visit microposts_path
        click_on 'つぶやきサンプル', match: :first 
        page.accept_confirm do
          click_on 'つぶやき削除'
        end
        visit microposts_path
        expect(page).to have_content 'つぶやき一覧'
    end
  end
end