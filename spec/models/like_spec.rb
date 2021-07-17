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

    # it 'diary_idとuser_idの組み合わせは一意であること' do
    #   another_like = build(:like, user_id: like.user_id, diary_id: like.diary_id)
    #   expect(another_like).to be_invalid
    # end

    # it 'micropost_idとuser_idの組み合わせは一意であること' do
    #   another_like = build(:like, user_id: like.user_id, micropost_id: like.micropost_id)
    #   expect(another_like).to be_invalid
    # end
  end
end

  describe 'アソシエーション' do
    let(:association) do
    described_class.reflect_on_association(target)
   end

  context 'user' do
    # targetは :userに指定
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
