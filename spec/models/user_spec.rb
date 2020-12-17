require 'rails_helper'

RSpec.describe User, type: :model do

  describe '#signup' do
    before do
      @user = build(:user)
    end
    it "email should be present" do
      @user.email = nil
      expect(@user).not_to be_valid
      expect(@user.errors[:email]).to include("が入力されていません。")
    end
  
    it "password should be present" do
      @user.password = nil
      expect(@user).not_to be_valid
      expect(@user.errors[:password]).to include("が入力されていません。")
    end
    
    it "password should be at least 6 letters" do
      @user.password = 'aaaaa'
      expect(@user).not_to be_valid
      expect(@user.errors[:password]).to include("は6文字以上に設定して下さい。")
    end
  
    it "password and password_confirmation should be same" do
      @user.password = 'password1'
      @user.password_confirmation = 'password2'
      expect(@user).not_to be_valid
      expect(@user.errors[:password_confirmation]).to include("が一致しません。")
    end
  end
end
