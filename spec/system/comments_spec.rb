require 'rails_helper'

RSpec.describe 'コメント', type: :system,js: true do
  let!(:user) { FactoryBot.create(:user) }
  let!(:micropost) { FactoryBot.create(:micropost, user_id: user.id) }
  let!(:diary) { FactoryBot.create(:diary, user_id: user.id) }
  let!(:comment_micropost) { FactoryBot.create(:comment, user_id: user.id, micropost_id: micropost.id) }
  let!(:comment_diary) { FactoryBot.create(:comment, user_id: user.id, diary_id: diary.id) }

  before do
    sign_in_as user
  end

   it 'つぶやきにコメントする' do
     click_on '自分のつぶやき'
     click_on "つぶやきサンプル"
     fill_in 'comment[content]', with: 'サンプル'
       expect do
         click_on "コメントする"
         expect(page).to have_css '.post_delete_show', visible: false
       end.to change { Comment.count }.by(1)
    end

    it 'つぶやきのコメントを削除する' do
      click_on '自分のつぶやき'
      click_on "つぶやきサンプル"
        expect do
          find(".comment_delete").click
          page.driver.browser.switch_to.alert.text == 'コメントを削除しますか?'
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_css '.section-title_post', visible: false
        end.to change { Comment.count }.by(-1)
    end

   it '日記にコメントする' do
     click_on '自分の日記'
     click_on "タイトル"
     fill_in 'comment[content]', with: 'サンプル'
       expect do
         click_on "コメントする"
         expect(page).to have_css '.diary_delete_show', visible: false
       end.to change { Comment.count }.by(1)
    end

    it '日記のコメントを削除する' do
      click_on '自分の日記'
      click_on "タイトル"
        expect do
          find(".diary_comment_delete").click
          page.driver.browser.switch_to.alert.text == '本当に削除してもよろしいですか?'
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_css '.section-title_diary', visible: false
        end.to change { Comment.count }.by(-1)
    end
end
