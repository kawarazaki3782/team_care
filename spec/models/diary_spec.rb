require 'rails_helper'

RSpec.describe Diary, type: :model do
  describe 'バリデーション' do
    subject(:user) { FactoryBot.create(:user) }
    subject(:diary) { FactoryBot.build(:diary, user_id: user.id) }

    it '正常に投稿できる' do
      expect(diary).to be_valid
    end

    it 'user_idがなければ無効' do
      diary.user_id = nil
      expect(diary).to be_invalid
      expect(diary.save).to be_falsey
    end

    it 'titleがないと無効' do
      diary.title = nil
      expect(diary).to be_invalid
      expect(diary.save).to be_falsey
    end

    it 'titleに絵文字があっても投稿できる' do
      diary.title = '😃'
      expect(diary).to be_valid
    end

    context 'content' do
      it 'contentがないと無効' do
        diary.content = nil
        expect(diary).to be_invalid
        expect(diary.save).to be_falsey
      end

      it 'contentが5000文字以内なら投稿できる' do
        diary.content = 'a' * 5000
        expect(diary).to be_valid
      end

      it 'contentに絵文字があっても投稿できる' do
        diary.content = '😃'
        expect(diary).to be_valid
      end

      it 'contentが5000文字以上だと無効' do
        diary.content = 'a' * 5001
        expect(diary).to be_invalid
        expect(diary.save).to be_falsey
      end

      it '画像がなくても投稿できる' do
        diary.diary_image = nil
        expect(diary).to be_valid
      end

      it 'statusがないと無効' do
        diary.status = nil
        expect(diary).to be_invalid
        expect(diary.save).to be_falsey
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
