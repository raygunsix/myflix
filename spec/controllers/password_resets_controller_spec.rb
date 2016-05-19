require 'spec_helper'

describe PasswordResetsController do
  describe 'GET show' do
    it 'requires show template if the token is valid' do
      alice = Fabricate(:user)
      alice.update_column(:token, '12345')
      get :show, id: '12345'
      response.should render_template :show
    end
    it 'redirects to the expired token page if the token is not valid' do
      get :show, id: '12345'
      response.should redirect_to expired_token_path
    end
    it 'sets @token' do
      alice = Fabricate(:user)
      alice.update_column(:token, '12345')
      get :show, id: '12345'
      assigns(:token).should == '12345'
    end
  end

describe "POST create" do

    context "with valid token" do
      it "redirects to sign in page" do
        alice = Fabricate(:user, password: 'old_password')
        alice.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        response.should redirect_to sign_in_path
      end

      it "updates user password" do
        alice = Fabricate(:user, password: 'old_password')
        alice.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        alice.reload.authenticate('new_password').should be_truthy
      end

      it "regenerates the user token" do
        alice = Fabricate(:user, password: 'old_password')
        alice.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        alice.reload.token.should_not == '12345'
      end
    end

    context "with invalid token" do
      it "redirects to the expired token path" do
        post :create, token: '12345', password: 'some_password'
        response.should redirect_to expired_token_path
      end
    end
  end
end