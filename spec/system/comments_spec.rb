require 'rails_helper'

RSpec.describe 'コメント', type: :system, js: true do
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
    click_on 'つぶやきサンプル'
    fill_in 'comment[content]', with: 'サンプル'
    expect do
      click_on 'コメントする'
      expect(page).to have_css '.post_delete_show', visible: false
    end.to change { Comment.count }.by(1)
  end

  it 'つぶやきのコメントを削除する' do
    click_on '自分のつぶやき'
    click_on 'つぶやきサンプル'
    expect do
      find('.comment_delete').click
      page.driver.browser.switch_to.alert.text == 'コメントを削除しますか?'
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_css '.section-title_post', visible: false
    end.to change { Comment.count }.by(-1)
  end

  it '日記にコメントする' do
    click_on '自分の日記'
    click_on 'タイトル'
    fill_in 'comment[content]', with: 'サンプル'
    expect do
      click_on 'コメントする'
      expect(page).to have_css '.diary_delete_show', visible: false
    end.to change { Comment.count }.by(1)
  end

  it '日記のコメントを削除する' do
    click_on '自分の日記'
    click_on 'タイトル'
    expect do
      find('.diary_comment_delete').click
      page.driver.browser.switch_to.alert.text == '本当に削除してもよろしいですか?'
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_css '.section-title_diary', visible: false
    end.to change { Comment.count }.by(-1)
  end

  describe '例外処理', type: :system, js: true do
    let!(:user) { FactoryBot.create(:user) }
    let!(:other_user) { FactoryBot.create(:user, name: 'その他ユーザー', email: 'sample@gmail.com') }
    let!(:other_micropost) { FactoryBot.create(:micropost, user_id: other_user.id, content: 'つぶやきサンプル2') }
    let!(:other_diary) { FactoryBot.create(:diary, user_id: other_user.id, title: 'タイトルサンプル') }

    it 'つぶやきにコメントする直前でユーザーが削除' do
      find('a.btn_base_users', match: :first).click
      click_on 'その他ユーザー'
      click_on 'つぶやきサンプル2'
      fill_in 'comment[content]', with: 'サンプル'
      find('.section-title_post', match: :first)
      User.find_by(name: 'その他ユーザー').destroy
      click_on 'コメントする'
      expect(page).to have_text 'コメントを投稿できませんでした'
    end

    it '日記にコメントする直前でユーザーが削除' do
      find('a.btn_base_users', match: :first).click
      click_on 'その他ユーザー'
      click_on 'タイトルサンプル'
      fill_in 'comment[content]', with: 'サンプル'
      User.find_by(name: 'その他ユーザー').destroy
      click_on 'コメントする'
      expect(page).to have_text 'コメントを投稿できませんでした'
    end

    it 'つぶやきを削除する直前でユーザーが削除' do
      find('a.btn_base_users', match: :first).click
      click_on 'その他ユーザー'
      click_on 'つぶやきサンプル2'
      fill_in 'comment[content]', with: 'サンプル'
      click_on 'コメントする'
      find(".section-title_post", text: "つぶやき詳細")
      User.find_by(name: 'その他ユーザー').destroy
      find('.comment_delete').click
      page.driver.browser.switch_to.alert.text == 'コメントを削除しますか?'
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_text 'コメントが削除できませんでした'
    end

    it '日記を削除する直前でユーザーが削除' do
      find('a.btn_base_users', match: :first).click
      click_on 'その他ユーザー'
      click_on 'タイトルサンプル'
      fill_in 'comment[content]', with: 'サンプル'
      click_on 'コメントする'
      find(".section-title_diary", text: "日記詳細")
      User.find_by(name: 'その他ユーザー').destroy
      find('.diary_comment_delete').click
      page.driver.browser.switch_to.alert.text == '本当に削除してもよろしいですか?'
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_text 'コメントが削除できませんでした'
    end
  end
end