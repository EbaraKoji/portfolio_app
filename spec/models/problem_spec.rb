require 'rails_helper'

RSpec.describe Problem, type: :model do
  # it { is_expected.to validate_uniqueness_of(:title).scoped_to(:user_id) }
  describe "Problem" do
    let (:problem) { create(:problem) }

    it "with valid params" do 
      expect(problem) .to be_valid
    end

    it "requires user" do
      problem.user_id = nil
      expect(problem) .not_to be_valid
    end

    it "requires title" do
      problem.title = nil
      expect(problem) .not_to be_valid
    end

    it "requires content" do
      problem.content = nil
      expect(problem) .not_to be_valid
    end

    it "title over 50 letters is invalid " do
      problem.title = "a" * 51
      expect(problem) .not_to be_valid
    end

    it "title with 50 letters is valid " do
      problem.title = "a" * 50
      expect(problem) .to be_valid
    end

    it "title within 50 letters is valid " do
      problem.title = "a" * 49
      expect(problem) .to be_valid
    end

    it "same title is invalid" do
      problem.save
      new_problem = build(:problem, title: problem.title)
      expect(new_problem) .not_to be_valid
    end

    it "content over 4095 letters is invalid" do
      problem.content = "a" * 4096
      expect(problem) .not_to be_valid
    end

    it "content with 4095 letters is invalid" do
      problem.content = "a" * 4095
      expect(problem) .to be_valid
    end

    it "content within 4095 letters is invalid" do
      problem.content = "a" * 4094
      expect(problem) .to be_valid
    end
  end
end