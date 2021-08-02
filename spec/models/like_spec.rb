require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'バリデーション' do
    context 'likeを保存できる場合' do
      let(:like) { create(:like) }
        it '正常に保存できること' do
          expect(like).to be_valid
        end
    end

    context 'likeを保存できない場合' do
      let(:like) { build(:like) }
        it 'user_idが存在しないと保存できない' do
          like.user_id = nil
          expect(like).to be_invalid
        end
      end

    context '一意性のテスト' do
      let(:like) { create(:like) }
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
