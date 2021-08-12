require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'バリデーション' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:notification) do
      build(
        :notification,
        visiter_id: user1.id,
        visited_id: user2.id
      )
    end

    describe '正常に保存できる場合' do
      describe 'micropost_likeに関するテスト' do
        it 'likeを正常に保存できること' do
          notification.action = 'micropost_like'
          expect(notification).to be_valid
        end
      end

      describe 'micropost_commentに関するテスト' do
        it 'commentを正常に保存できること' do
          notification.action = 'micropost_comment'
          expect(notification).to be_valid
        end
      end

      describe 'diary_likeに関するテスト' do
        it 'likeを正常に保存できること' do
          notification.action = 'diary_like'
          expect(notification).to be_valid
        end
      end

      describe 'diary_commentに関するテスト' do
        it 'commentを正常に保存できること' do
          notification.action = 'diary_comment'
          expect(notification).to be_valid
        end
      end

      describe 'followに関するテスト' do
        it 'followを正常に保存できること' do
          notification.action = 'follow'
          expect(notification).to be_valid
        end
      end
    end

    describe '正常に保存できない場合' do
      it 'actionの文字列で指定した以外のものは無効' do
        notification.action = 'aaa'
        expect(notification).to be_invalid
      end
    end
  end

  describe 'アソシエーション' do
    let(:association) do
      described_class.reflect_on_association(target)
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

    context 'comment' do
      let(:target) { :comment }
      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'Comment' }
    end

    context 'visiter' do
      let(:target) { :visiter }
      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'User' }
    end

    context 'visited' do
      let(:target) { :visited }
      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'User' }
    end
  end
end
