require 'rails_helper'

RSpec.describe Entry, type: :model do
  describe '#バリデーション' do
    context 'entryが保存できる場合' do
      let(:entry) { create(:entry) }

      it '正常に保存できること' do
        expect(entry).to be_valid
      end
    end

    context 'entryが保存できない場合' do
      let(:entry) { build(:entry) }

      it 'user_idが存在しない場合は無効' do
        entry.user_id = ''
        expect(entry).to be_invalid
      end

      it 'room_idが存在しない場合は無効' do
        entry.room_id = ''
        expect(entry).to be_invalid
      end
    end

    context '一意性のテスト' do
      let(:entry) { create(:entry) }

      it 'user_idとroom_idの組み合わせは一意であること' do
        another_entry = build(:entry, user_id: entry.user_id, room_id: entry.room_id)
        expect(another_entry).to be_invalid
      end
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

  context 'room' do
    let(:target) { :room }
    it { expect(association.macro).to eq :belongs_to }
    it { expect(association.class_name).to eq 'Room' }
  end
end
end
