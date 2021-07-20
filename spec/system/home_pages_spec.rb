require "rails_helper"

describe "リンクの確認（ログイン済み）", js: true do
  let!(:user) { FactoryBot.create(:user, name: "一般ユーザー") }

  before do
    sign_in_as user
    visit root_path
  end

  it "ヘッダーリンクが表示されること" do
    within "header" do
      aggregate_failures do
        expect(page).to have_link("ホーム")
        expect(page).to have_link("マイページ")
        expect(page).to have_link("つぶやき投稿")
        expect(page).to have_link("日記投稿")
        expect(page).to have_link("通知")
        expect(page).to have_link("ログアウト")
      end
    end
  end

  it "フッターリンクが表示されること" do
    within "footer" do
      aggregate_failures do
        expect(page).to have_link("マイページ")
        expect(page).to have_link("つぶやき投稿")
        expect(page).to have_link("日記投稿")
        expect(page).to have_link("ログアウト")
      end
    end
  end
end

describe "リンクの確認（ログイン未）", js: true do
    let!(:user) { FactoryBot.create(:user, name: "一般ユーザー") }
  
    before do
      visit root_path
    end
  
    it "ヘッダーリンクが表示されること" do
      within "header" do
        aggregate_failures do
          expect(page).to have_link("ホーム")
          expect(page).to have_link("チームケアとは")
          expect(page).to have_link("新規登録")
          expect(page).to have_link("ログイン")
          expect(page).to have_link("お問い合わせ")
        end
      end
    end
  
    it "フッターリンクが表示されること" do
      within "footer" do
        aggregate_failures do
          expect(page).to have_link("新規登録")
          expect(page).to have_link("ログイン")
          expect(page).to have_link("お問い合わせ")
        end
      end
    end
  end