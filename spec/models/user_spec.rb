require 'rails_helper'

RSpec.describe User, type: :model do

  it "名前、メールアドレス、パスワード、性別、生年月日、住所、介護の形態があれば有効" do
   expect(FactoryBot.build(:user)).to be_valid
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

  it "パスワードがなければ無効" do
    user = FactoryBot.build(:user, password:nil)
    user.valid?
    expect(user.errors.added?(:password, :blank)).to be_truthy
  end

  it "性別がなければ無効" do
    user = FactoryBot.build(:user, gender:nil)
    user.valid?
    expect(user.errors.added?(:gender, :blank)).to be_truthy
  end

  it "生年月日がなければ無効" do
    user = FactoryBot.build(:user, birthday:nil)
    user.valid?
    expect(user.errors.added?(:birthday, :blank)).to be_truthy
  end

  it "住所がなければ無効" do
    user = FactoryBot.build(:user, address:nil)
    user.valid?
    expect(user.errors.added?(:address, :blank)).to be_truthy
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

  it "パスワードが暗号化されていなければ無効"do
    user = FactoryBot.create(:user)
    expect(user.password_digest).to_not eq "password"
  end 

  it "パスワードとパスワードの確認用の入力が異なっていたら無効" do 
    expect(FactoryBot.build(:user,password:"password",password_confirmation: "passward")).to_not be_valid 
  end 

  it "パスワードが5文字以下なら無効"do
    user = FactoryBot.build(:user, password: "a" * 5 )
    user.valid?
    expect(user.errors[:password]).to include("は6文字以上で入力してください")
  end
  
  it "プロフィールが1000文字を超えていたら無効"do
    user = FactoryBot.build(:user, profile: "a" * 1001 )
    user.valid?
    expect(user.errors[:profile]).to include("は1000文字以内で入力してください")
 end
end
