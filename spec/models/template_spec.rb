require 'rails_helper'

RSpec.describe Template, type: :model do
  describe 'バリデーション' do
    subject(:user) { FactoryBot.create(:user) }
    subject(:template) { FactoryBot.build(:template, user_id: user.id) }

    it '正常に投稿できる' do
      expect(template).to be_valid
    end

    it 'user_idがなければ無効' do
      template.user_id = nil
      expect(template).to be_invalid
      expect(template.save).to be_falsey
    end

    context 'content' do
      it 'contentがないと無効' do
        template.content = nil
        expect(template).to be_invalid
        expect(template.save).to be_falsey
      end

      it '140文字以内なら有効' do
        template.content = 'a' * 140
        expect(template).to be_valid
      end

      it '141文字以上だと無効' do
        template.content = 'a' * 141
        expect(template).to be_invalid
        expect(template.save).to be_falsey
      end

      it '絵文字を投稿できること' do
        template.content = '😃' 
        expect(template).to be_valid
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
  end
end
