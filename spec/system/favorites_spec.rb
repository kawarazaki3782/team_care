require 'rails_helper'

RSpec.describe 'Likes', type: :system,js: true do
  let(:user) { FactoryBot.create(:user) }
  let(:micropost) { FactoryBot.create(:micropost, user_id: user.id) }
  let(:favorite) { FactoryBot.create(:favorite, user_id: user.id, micropost_id: micropost.id) }
  
  before do
    sign_in_as user
  end

  it 'つぶやきをお気に入りに登録する' do
    visit root_path
    find('.home_text', match: :first).click
#       expect do
#         find('.micropost_show section')
#         expect(page).to have_css '.btn_base_favorites', visible: false
#       end.to change { Favorite.count }.by(1)
#    end
  end
end


    