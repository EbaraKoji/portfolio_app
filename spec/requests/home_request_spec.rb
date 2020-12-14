require 'rails_helper'

RSpec.describe "Homes", type: :request do

  let(:base_title) { 'Portfolio App' }

  describe "GET /top" do
    it "returns http success" do
      get root_url
      expect(response).to have_http_status(:success)
      assert_select "title", "Top | #{base_title}"
    end
  end

  describe "GET /help" do
    it "returns http success" do
      get help_url
      expect(response).to have_http_status(:success)
      assert_select "title", "Help | #{base_title}"
    end
  end

  describe "GET /about" do
    it "returns http success" do
      get about_url
      expect(response).to have_http_status(:success)
      assert_select "title", "About | #{base_title}"
    end
  end

end
