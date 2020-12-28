require 'rails_helper'

RSpec.describe User, type: :model do

  describe '#signup' do
  let(:user) { build(:user) }
  let(:another_user) { build(:user) }

    it "email should be present" do
      user.email = nil
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("が入力されていません。")
    end

    it "email should be unique" do
      user.save
      another_user.email = user.email
      expect(another_user).not_to be_valid
    end
  
    it "password should be present" do
      user.password = nil
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("が入力されていません。")
    end
    
    it "password should be at least 6 letters" do
      user.password = 'aaaaa'
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("は6文字以上に設定して下さい。")
    end
  
    it "password and password_confirmation should be same" do
      user.password = 'password1'
      user.password_confirmation = 'password2'
      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to include("が一致しません。")
    end

    it "name should be present" do
      user.name = nil
      expect(user).not_to be_valid
    end

    it "name should be unique" do
      user.save
      another_user.name = user.name
      expect(another_user).not_to be_valid
    end

    it "name over 50 letters is invalid" do
      user.name = "a" * 51
      expect(user).not_to be_valid
    end

    it "name with 50 letters is valid" do
      user.name = "a" * 50
      expect(user).to be_valid
    end

    it "name within 50 letters is valid" do
      user.name = "a" * 49
      expect(user).to be_valid
    end
  end
end
