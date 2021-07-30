require 'rails_helper'

RSpec.describe 'Likes', type: :system,js: true do
  let(:user) { FactoryBot.create(:user) }
  let(:micropost) { FactoryBot.create(:micropost, user_id: user.id) }
  let(:like) { FactoryBot.create(:like, user_id: user.id, micropost_id: micropost.id) }
  
  before do
    sign_in_as user
  end

   it 'つぶやきにいいねをする' do
    visit root_path
    expect(page).to have_current_path root_path
      expect do
         find('.likes_unliked', visible: false).click
         expect(page).to have_css '.likes_liked', visible: false
       end.to change { Like.count }.by(1)
    end
end
    #   it 'いいねを取り消す' do
#     like = create(:like)

#     micropost = like.micropost

#     user = like.user

#     sign_in user

#     visit micropost_path(micropost)

#     expect do
#       find('.likes-liked').click

#       expect(page).to have_css '.likes-unliked', visible: false
#     end.to change { Like.count }.by(-1)

#     expect(current_path).to eq micropost_path(micropost)
#   end
# end
