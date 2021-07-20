require 'rails_helper'

RSpec.describe 'Likes', type: :system do
    let(:user) { FactoryBot.create(:user) }
    let(:micropost) { FactoryBot.create(:micropost) }
    let(:like) { FactoryBot.create(:like) }
    before do
    sign_in_as user
    user = like.user
   end
    it 'つぶやきにいいねをする' do
    micropost = like.micropost
    click_on "自分のつぶやき"    
    expect do
        find('.likes-unliked').click
  
        expect(page).to have_css '.likes-liked', visible: false
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
