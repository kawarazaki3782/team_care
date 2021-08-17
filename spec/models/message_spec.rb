require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'バリデーション' do
    context 'messageを保存できる場合' do
      let(:message) { create(:message) }

      it '正常に保存できること' do
        expect(message).to be_valid
      end

      it 'contentに絵文字が使えること' do
        message.content = '😃'
        expect(message).to be_valid
        message.save
      end

      it 'user_idが違えばroom_idが同じでも保存できること' do
        another_user = create(:user)
        another_message = build(:message,
                                user_id: another_user.id, room_id: message.room_id)
        expect(another_message).to be_valid
      end
    end

    context 'messageを保存できない場合' do
      let(:message) { build(:message) }

      it 'user_idが存在しないと保存できないこと' do
        message.user_id = ''
        expect(message).to be_invalid
      end

      it 'room_idが存在しないと保存できないこと' do
        message.room_id = ''
        expect(message).to be_invalid
      end

      it 'contentが存在しないと保存できないこと' do
        message.content = ''
        expect(message).to be_invalid
      end

      it 'contentが151文字以上だと保存できないこと' do
        message.content = 'a' * 151
        expect(message).to be_invalid
      end
    end

    context '一意性のテスト' do
      let(:message) { create(:message) }

      it 'user_idとroom_idとの組み合わせが一意であること' do
        another_message = build(:message)
        expect(another_message).to be_invalid
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

    context 'room' do
      let(:target) { :room }
      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'Room' }
    end
  end
end
