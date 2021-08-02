require "rails_helper"

RSpec.describe Inquiry, type: :model do
  it "正常に投稿できる" do
    inquiry = Inquiry.new(name: "aaa", email: "sample@gmail.com", message: "こんにちは")
    expect(inquiry).to be_valid
  end

  it"名前が入力されていないと無効" do
    inquiry = Inquiry.new(name: "", email: "sample@gmail.com", message: "こんにちは")
    inquiry.valid?
    expect(inquiry.errors[:name]).to include("名前を入力してください")
  end 

  it"メールアドレスが入力されていないと無効" do
    inquiry = Inquiry.new(name: "aaa", email: "", message: "こんにちは")
    inquiry.valid?
    expect(inquiry.errors[:email]).to include("メールアドレスを入力してください")
  end 
end
