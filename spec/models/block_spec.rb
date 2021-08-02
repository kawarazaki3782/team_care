require 'rails_helper'

RSpec.describe Block, type: :model do
  describe 'アソシエーション' do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context 'blocker' do
      let(:target) { :blocker }
      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'User' }
    end

    context 'blocking' do
      let(:target) { :blocked }
      it { expect(association.macro).to eq :belongs_to  }
      it { expect(association.class_name).to eq 'User' }
    end
  end
end
