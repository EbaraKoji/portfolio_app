require 'rails_helper'

RSpec.describe Problem, type: :model do
  describe "Problem" do
    let! (:problem) { create(:problem) }
    
    it "with valid params" do 
      expect(problem) .to be_valid
    end

    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_uniqueness_of(:title).case_insensitive.scoped_to(:user_id) }
    it { is_expected.to validate_length_of(:title).is_at_most(50) }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_length_of(:content).is_at_most(4095) }
  end
end