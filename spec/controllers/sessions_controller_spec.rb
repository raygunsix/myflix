require 'spec_helper'

describe SessionsController do

  describe 'GET new' do
    context 'with logged in user' do
      let!(:user) { Fabricate(:user) }

      it 'should redirect to the home page' do
        session[:user_id] = user.id
        get :new
        response.should redirect_to home_path
      end
    end

    context 'with logged out user' do
      it 'should render the new template' do
        get :new
        response.should render_template :new
      end
    end
  end

  describe 'POST create' do

    context 'with valid credentials' do
      let!(:user) { Fabricate(:user) }
      before { post :create, email: user.email, password: user.password }

      it 'should log in the user' do
        session[:user_id].should == user.id
      end

      it 'should redirect to the home page' do
        response.should redirect_to home_path
      end
    end

    context 'with invalid credentials' do
      let(:user) { Fabricate.attributes_for(:user, email: nil) }
      before { post :create, user }

      it 'should not log the user in' do
        session[:user_id].should be_nil
      end

      it 'should render the new template' do
        response.should render_template :new
      end
    end
  end

  describe 'POST destroy' do
    let!(:user) { Fabricate(:user) }

    it 'deletes the user session' do
      session[:user_id] == user.id
      get :destroy
      session[:user_id].should be_nil
    end

    it 'redirects the user' do
      get :destroy
      response.should redirect_to root_path
    end
  end

end