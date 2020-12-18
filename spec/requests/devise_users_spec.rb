require 'rails_helper'

RSpec.describe "UserAuthentications", type: :request do
  let(:user) { create(:user) }
  let(:user_params) { attributes_for(:user) }
  let(:invalid_user_params) { attributes_for(:user, email: "") }

  describe "Create User" do
    before do
      ActionMailer::Base.deliveries.clear
    end

    context "valid params" do
      it "succeessful request" do
        get new_user_registration_path
        post user_registration_path, params: { user: user_params }
        expect(response.status).to eq 302
      end

      it "send confirmation mail" do
        post user_registration_path, params: { user: user_params }
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end

      it "successful create" do
        expect do
          post user_registration_path, params: { user: user_params }
        end.to change(User, :count).by 1
      end

      it "redirect to root_url" do
        post user_registration_path, params: { user: user_params }
        expect(response).to redirect_to root_url
      end
    end

    context 'invalid params' do
      it 'successful request' do
        post user_registration_path, params: { user: invalid_user_params }
        expect(response.status).to eq 200
      end

      it 'does not send confirmation mail' do
        post user_registration_path, params: { user: invalid_user_params }
        expect(ActionMailer::Base.deliveries.size).to eq 0
      end

      it 'fail to create' do
        expect do
          post user_registration_path, params: { user: invalid_user_params }
        end.to_not change(User, :count)
      end

      it 'show errors' do
        post user_registration_path, params: { user: invalid_user_params }
        expect(response.body).to include 'メールアドレス が入力されていません。'
        assert_select "div#error_explanation"
      end
    end
  end 
end