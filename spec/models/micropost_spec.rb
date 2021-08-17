require 'rails_helper'

RSpec.describe Micropost, type: :model do
  describe 'バリデーション' do
    subject(:user) { FactoryBot.create(:user) }
    subject(:micropost) { FactoryBot.build(:micropost, user_id: user.id) }

    it '正常に投稿できる' do
      expect(micropost).to be_valid
      micropost.save
    end

    it 'user_idがなければ無効' do
      micropost.user_id = nil
      expect(micropost).to be_invalid
      expect(micropost.save).to be_falsey
    end

    context 'content' do
      it 'contentがないと無効' do
        micropost.content = nil
        expect(micropost).to be_invalid
        expect(micropost.save).to be_falsey
      end

      it 'contentが140文字以内なら投稿できる' do
        micropost.content = 'a' * 140
        expect(micropost).to be_valid
        micropost.save
      end

      it 'contentが絵文字でも投稿できる' do
        micropost.content = '😃'
        expect(micropost).to be_valid
        micropost.save
      end

      it 'contentが140文字以上だと無効' do
        micropost.content = 'a' * 141
        expect(micropost).to be_invalid
        expect(micropost.save).to be_falsey
      end

      it '画像がなくても投稿できる' do
        micropost.post_image = nil
        expect(micropost).to be_valid
        micropost.save
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

    context 'category' do
      let(:target) { :category }
      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'Category' }
    end

    context 'comments' do
      let(:target) { :comments }
      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Comment' }
    end

    context 'likes' do
      let(:target) { :likes }
      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Like' }
    end

    context 'favorites' do
      let(:target) { :favorites }
      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Favorite' }
    end

    context 'notifications' do
      let(:target) { :notifications }
      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Notification' }
    end
  end
end
