require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'バリデーション' do
    let(:comment) { FactoryBot.build(:comment) }

    it "正常に投稿できる" do
      expect(comment).to be_valid
      comment.save
    end
    
    context "content" do
      it "contentがないと無効" do
        comment.content = nil
        expect(comment).to be_invalid
        expect(comment.save).to be_falsey
      end

      it '140文字以内なら有効' do
        comment.content = 'a' * 140
        expect(comment).to be_valid
        comment.save
      end

      it '141文字以上だと無効' do
        comment.content = 'a' * 141
        expect(comment).to be_invalid
        expect(comment.save).to be_falsey
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
end
