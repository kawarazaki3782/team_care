require 'rails_helper'

RSpec.describe 'Likes', type: :system do
    let(:user) { create(:user) }
    let(:micropost) { create(:micropost) }
    let(:like) { create(:like, user_id: user.id, micropost_id: micropost.id) }
    before do
    sign_in_as user
   end
    it 'つぶやきにいいねをする' do
    click_on "自分のつぶやき"    
    expect(page).to have_current_path microposts_path
    
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
