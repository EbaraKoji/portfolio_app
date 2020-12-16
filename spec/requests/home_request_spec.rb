require 'rails_helper'

RSpec.describe "Homes", type: :request do

  let(:base_title) { 'Portfolio App' }

  describe "GET /top" do
    it "returns http success" do
      get root_url
      expect(response).to have_http_status(:success)
      assert_select "title", full_title('Top')
    end
  end

  describe "GET /help" do
    it "returns http success" do
      get help_url
      expect(response).to have_http_status(:success)
      assert_select "title", full_title('Help')
    end
  end

  describe "GET /about" do
    it "returns http success" do
      get about_url
      expect(response).to have_http_status(:success)
      assert_select "title", full_title('About')
    end
  end

end
