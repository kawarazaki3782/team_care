require 'rails_helper'

RSpec.describe Room, type: :model do
  describe 'アソシエーション' do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context 'messages' do
      let(:target) { :messages }
      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Message' }
    end

    context 'entries' do
      let(:target) { :entries }
      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Entry' }
    end

    context 'users' do
      let(:target) { :users }
      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'User' }
    end
  end
end
