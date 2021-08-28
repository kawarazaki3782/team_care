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
    find('input[type="textarea"]').set('サンプルコメント')
    expect do
      click_on 'コメントする'
      page.accept_confirm
      expect(page).to have_css '.post_delete_show', visible: false
    end.to change { Comment.count }.by(1)
  end

  it 'つぶやきのコメントを削除する' do
    click_on '自分のつぶやき'
    click_on 'つぶやきサンプル'
    expect do
      click_on '削除', match: :first
      page.accept_confirm
      expect(page).to have_css '.section-title_post', visible: false
    end.to change { Comment.count }.by(-1)
  end

  it '日記にコメントする' do
    click_on '自分の日記'
    click_on 'タイトル'
    find('input[type="textarea"]').set('サンプルコメント')
    expect do
      click_on 'コメントする'
      page.accept_confirm
      expect(page).to have_css '.comment_content', visible: false
    end.to change { Comment.count }.by(1)
  end

  it '日記のコメントを削除する' do
    click_on '自分の日記'
    click_on 'タイトル'
    expect do
      click_on '削除', match: :first
      page.accept_confirm
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
      find('input[type="textarea"]').set('サンプルコメント')
      User.find_by(name: 'その他ユーザー').destroy
      accept_alert("コメントの投稿に失敗しました")do
        click_on'コメントする'
      end
      expect(page).not_to have_text('サンプルコメント')
    end
  
    it '日記にコメントする直前でユーザーが削除' do
      find('a.btn_base_users', match: :first).click
      click_on 'その他ユーザー'
      click_on 'タイトルサンプル'
      find('input[type="textarea"]').set('サンプルコメント')
      User.find_by(name: 'その他ユーザー').destroy
      accept_alert("コメントの投稿に失敗しました")do
        click_on'コメントする'
      end
      expect(page).not_to have_text('サンプルコメント')
    end
  end
end