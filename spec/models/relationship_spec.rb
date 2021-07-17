require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe 'アソシエーション' do
    let(:association) do
    described_class.reflect_on_association(target)
   end

context 'following' do
  let(:target) { :follower }
  it { expect(association.macro).to eq :belongs_to }
  it { expect(association.class_name).to eq 'User' }
end

context 'follower' do
  let(:target) { :followed }
  it { expect(association.macro).to eq :belongs_to  }
  it { expect(association.class_name).to eq 'User' }
end
end
end