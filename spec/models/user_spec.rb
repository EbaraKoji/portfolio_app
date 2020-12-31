require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_length_of(:password).is_at_least(6) }
  it "password_confirmation should be same" do
    user.password = 'password1'
    user.password_confirmation = 'password2'
    expect(user).not_to be_valid
    expect(user.errors[:password_confirmation]).to include("が一致しません。")
  end

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  it { is_expected.to validate_length_of(:name).is_at_most(50) }

  it { is_expected.to have_many(:problems) }
end
