require 'spec_helper'

describe SessionsController do
  let!(:user) { Fabricate(:user) }

  describe 'GET new' do
    it 'should redirect to the home page if the user is logged in' do
      skip
      session[:id] = user.id
      get :new
      response.should render :new
    end
  end

  describe 'POST create' do
    it 'creates a session if the user supplies valid credentials' do
      skip
      post :create, user
      session[:id].should == user.id
    end
    it 'redirects if the user supplies invalid credentials' do
      skip
      post :create, Fabricate(:user, email: nil)
      response.should render :new
    end
  end

  describe 'POST destroy' do
    it 'deletes the user session' do
      skip
      get :destroy, user.id
      session[:id].should == nil
    end
  end

end