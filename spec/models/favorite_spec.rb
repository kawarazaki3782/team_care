require 'rails_helper'

RSpec.describe Favorite, type: :model do
  describe 'バリデーション' do
    context 'favoriteを保存できる場合' do
      let(:favorite) { create(:favorite) }
        it '正常に保存できること' do
            expect(favorite).to be_valid
            favorite.save
          end
        end

    context 'favoriteを保存できない場合' do
      let(:favorite) { build(:favorite) }
        it 'user_idが存在しないと保存できない' do
          favorite.user_id = nil
          expect(favorite).to be_invalid
        end
     end
  end

  describe 'アソシエーション' do
    let(:association) do
      described_class.reflect_on_association(target)
    end
     context 'user' do
       let(:target) { :user }
       it { expect(association.macro).to eq :belongs_to }
       it { expect(association.class_name).to eq 'User' }
     end

     context 'micropost' do
       let(:target) { :micropost }
       it { expect(association.macro).to eq :belongs_to }
       it { expect(association.class_name).to eq 'Micropost' }
     end
  
     context 'diary' do
       let(:target) { :diary }
       it { expect(association.macro).to eq :belongs_to  }
       it { expect(association.class_name).to eq 'Diary' }
     end
   end
end