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
      before { post :create, user: user }

      it 'creates the user' do
        User.first.email.should == user['email']
      end

      it 'redirects to the sign in page' do
        response.should redirect_to sign_in_path
      end
    end

    context "with invalid params" do
      let(:user) { Fabricate.attributes_for(:user, email: nil) }
      before { post :create, user: user }

      it 'does not create the user' do
        User.first.should be_nil
      end

      it 'redirects to the new user page' do
        response.should render_template :new
      end
    end
  end

  describe 'GET show' do
    it_behaves_like 'requires sign in' do
      let(:action) { get :show, id: 3 }
    end

    it 'sets @user' do
      set_current_user
      alice = Fabricate(:user)
      get :show, id: alice.id
      assigns(:user).should == alice
    end
  end

end