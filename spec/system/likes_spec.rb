require 'rails_helper'

RSpec.describe 'Likes', type: :system,js: true do
  let!(:user) { FactoryBot.create(:user) }
  let!(:micropost) { FactoryBot.create(:micropost, user_id: user.id) }
  let!(:diary) { FactoryBot.create(:diary, user_id: user.id) }

  before do
    sign_in_as user
  end

   it 'つぶやきにいいねをする' do
    click_on '自分のつぶやき'
      expect do
         find('.likes-liked', match: :first , visible: false).click
         expect(page).to have_css '.likes-unliked', visible: false
       end.to change { Like.count }.by(1)
    end

   it 'つぶやきのいいねを取り消す' do
     visit root_path
     find('.likes_unliked', match: :first , visible: false).click
       expect do
         find('.likes_liked', match: :first , visible: false).click
         expect(page).to have_css '.likes_unliked', visible: false
       end.to change { Like.count }.by(-1)
   end

   it '日記にいいねをする' do
    visit root_path
      expect do
         find('.likes_unliked_diary', match: :first , visible: false).click
         expect(page).to have_css '.likes_liked_diary', visible: false
       end.to change { Like.count }.by(1)
    end

   it '日記のいいねを取り消す' do
     visit root_path
     find('.likes_unliked_diary', match: :first , visible: false).click
       expect do
         find('.likes_liked_diary', match: :first , visible: false).click
         expect(page).to have_css '.likes_unliked_diary', visible: false
       end.to change { Like.count }.by(-1)
   end
end
