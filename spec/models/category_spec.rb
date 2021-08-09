require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'バリデーション' do
    subject(:user) { FactoryBot.create(:user) }
    subject(:category) { FactoryBot.build(:category, user_id: user.id) }

    it '正常に投稿できる' do
      expect(category).to be_valid
      category.save
    end

    it 'user_idがなければ無効' do
      category.user_id = nil
      expect(category).to be_invalid
      expect(category.save).to be_falsey
    end

    context 'name' do
      it 'nameがないと無効' do
        category.name = nil
        expect(category).to be_invalid
        expect(category.save).to be_falsey
      end

      it '20文字以内なら有効' do
        category.name = 'a' * 20
        expect(category).to be_valid
        category.save
      end

      it '21文字以上だと無効' do
        category.name = 'a' * 21
        expect(category).to be_invalid
        expect(category.save).to be_falsey
      end

      it 'nameが重複していたら無効' do
        FactoryBot.create(:category, name: 'カテゴリー')
        category = FactoryBot.build(:category, name: 'カテゴリー')
        category.valid?
        expect(category.errors[:name]).to include('はすでに存在します')
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

    context 'microposts' do
      let(:target) { :microposts }
      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Micropost' }
    end

    context 'diaries' do
      let(:target) { :diaries }
      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Diary' }
    end
  end
end
