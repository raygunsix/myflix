require 'spec_helper'

describe UsersController do

  describe 'GET new' do
    it 'sets the @user instance variable' do
      get :new
      assigns(:user).should be_an_instance_of(User)
    end
  end

  describe 'POST create' do

    context 'with valid params' do
      let(:user) { Fabricate.attributes_for(:user) }

      it 'creates the user' do
        post :create, user: user
        User.first.email.should == user['email']
      end

      it 'redirects to the sign in page' do
        post :create, user: user
        response.should redirect_to sign_in_path
      end
    end

    context "with invalid params" do
      let(:user) { Fabricate.attributes_for(:user, email: nil) }

      it 'does not create the user' do
        post :create, user: user
        User.first.should be_nil
      end

      it 'redirects to the new user page' do
        post :create, user: user
        response.should render_template :new
      end
    end
  end

end