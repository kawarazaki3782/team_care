require 'rails_helper'

RSpec.describe 'お気に入り', type: :system,js: true do
  let!(:user) { FactoryBot.create(:user) }
  let!(:micropost) { FactoryBot.create(:micropost, user_id: user.id) }
  let!(:diary) { FactoryBot.create(:diary, user_id: user.id) }

  before do
    sign_in_as user
  end

  it 'つぶやきをお気に入りに登録する' do
    click_on "自分のつぶやき"
    click_on "つぶやきサンプル"
      expect do
        find('.btn_base_favorites').click
        expect(page).to have_css '.btn_base_favorites', visible: false
      end.to change { Favorite.count }.by(1)
   end
  
   describe 'つぶやきのお気に入りを解除する' do
   let!(:favorite) { FactoryBot.create(:favorite, user_id: user.id, micropost_id: micropost.id) }
     it 'つぶやきのお気に入りを解除する' do
       click_on "自分のつぶやき"
       click_on "つぶやきサンプル"
         expect do
          find('.btn_base_favorites').click
          expect(page).to have_css '.btn_base_favorites', visible: false
         end.to change { Favorite.count }.by(-1)
      end
   end

   it '日記をお気に入りに登録する' do
    click_on "自分の日記"
    click_on "タイトル"
      expect do
        find('.btn_base_favorites').click
        expect(page).to have_css '.btn_base_favorites', visible: false
      end.to change { Favorite.count }.by(1)
   end
  
   describe '日記のお気に入りを解除する' do
   let!(:favorite) { FactoryBot.create(:favorite, user_id: user.id, diary_id: diary.id) }
     it 'つぶやきのお気に入りを解除する' do
       click_on "自分の日記"
       click_on "タイトル"
         expect do
          find('.btn_base_favorites').click
          expect(page).to have_css '.btn_base_favorites', visible: false
         end.to change { Favorite.count }.by(-1)
      end
   end
 end





    