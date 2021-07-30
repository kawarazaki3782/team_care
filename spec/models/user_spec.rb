require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
  it "名前、メールアドレス、パスワード、性別、生年月日、住所、介護の形態があれば有効" do
   expect(FactoryBot.build(:user)).to be_valid
  end

  it "メールフォーマットが有効な場合" do
    user = FactoryBot.build(:user, email: "aaron@example.com")
    addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        user.email = valid_address
        expect(user).to be_valid
      end
  end

  it "プロフィールイメージがnilでも登録できること" do
    user = FactoryBot.build(:user, profile_image:nil)
    expect(user).to be_valid
  end


  it "名前がなければ無効" do
    user = FactoryBot.build(:user, name:nil)
    user.valid?
    expect(user.errors.added?(:name, :blank)).to be_truthy
  end

  it "メールアドレスがなければ無効" do
    user = FactoryBot.build(:user, email:nil)
    user.valid?
    expect(user.errors.added?(:email, :blank)).to be_truthy
  end

  it "性別がなければ無効" do
    user = FactoryBot.build(:user, gender:nil)
    user.valid?
    expect(user.errors.added?(:gender, :blank)).to be_truthy
  end
  
  it "介護の形態がなければ無効" do
    user = FactoryBot.build(:user, long_teamcare:nil)
    user.valid?
    expect(user.errors.added?(:long_teamcare, :blank)).to be_truthy
  end

  it "名前が15文字を超えた場合は無効" do
    user = FactoryBot.build(:user, name: "a" * 16 )
    user.valid?
    expect(user.errors[:name]).to include("は15文字以内で入力してください")
  end

  it "メールアドレスが重複していたら無効"do
    FactoryBot.create(:user, email: "aaron@example.com")
    user = FactoryBot.build(:user, email: "aaron@example.com")
    user.valid?
    expect(user.errors[:email]).to include("はすでに存在します")
  end

  context 'パスワード' do
    subject(:user) { FactoryBot.build(:user) }
    it '空白だと登録できないこと' do
      user.password = nil
      expect(user).to be_invalid
      expect(user.errors[:password]).to include("を入力してください")
      expect(user.save).to be_falsey
    end
    it 'passwordとpassword_confirmationが一致していないと登録できないこと' do
      user.password = 'password_A'
      user.password_confirmation = 'password_B'
      expect(user).to be_invalid
      expect(user.errors[:password_confirmation]).to include("とPasswordの入力が一致しません")
      expect(user.save).to be_falsey
    end
    it '5文字以下だと登録できないこと' do
      user.password = 'a' * 5
      user.password_confirmation = 'a' * 5
      expect(user).to be_invalid
      expect(user.save).to be_falsey
    end
    it "パスワードが暗号化されていなければ無効"do
    expect(user.password_digest).to_not eq "password"
    end
    it '6文字なら登録できること' do
      user.password = 'a' * 6
      user.password_confirmation = 'a' * 6
      expect(user).to be_valid
      user.save
    end
  end

  it "プロフィールが1000文字を超えていたら無効"do
    user = FactoryBot.build(:user, profile: "a" * 1001 )
    user.valid?
    expect(user.errors[:profile]).to include("は1000文字以内で入力してください")
 end

  
 it "メールフォーマットが無効な場合" do
  user = FactoryBot.build(:user, email: "aaron@example.com")
  addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                 foo@bar_baz.com foo@bar+baz.com]
  addresses.each do |invalid_address|
    user.email = invalid_address
    expect(user).not_to be_valid
  end
end

describe 'アソシエーション' do
  let(:association) do
  described_class.reflect_on_association(target)
 end

    context 'micropost' do
      let(:target) { :microposts }
      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Micropost' }
    end
    
    context 'commnet' do
      let(:target) { :comments }
      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Comment' }
    end

    context 'diary' do
      let(:target) { :diaries }
      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Diary' }
    end

    context 'favorite' do
      let(:target) { :favorites }
      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Favorite' }
    end

    context 'category' do
      let(:target) { :categories }
      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Category' }
    end

    context 'Message' do
      let(:target) { :messages }
      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Message' }
    end

    context 'entry' do
      let(:target) { :entries }
      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Entry' }
    end

    context 'room' do
      let(:target) { :rooms }
      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Room' }
    end
  end
end
end