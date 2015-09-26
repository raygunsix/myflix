require 'spec_helper'

describe VideosController do

  describe 'GET show' do
    let(:family_guy) { Fabricate(:video) }

    it 'sets the @video instance variable for authenticated users' do
      session[:user_id] = Fabricate(:user).id
      get :show, id: family_guy.id
      assigns(:video).should == Video.first
    end

    it 'redirects to the sign in page for unauthenticated users' do
      get :show, id: family_guy.id
      response.should redirect_to sign_in_path
    end
  end

  describe "GET search" do
    let(:family_guy) { Fabricate(:video) }

    it 'sets the @results instance variable for authenticated users' do
      session[:user_id] = Fabricate(:user).id
      get :search, search_term: family_guy.title
      assigns(:results).should include Video.first
    end

    it 'redirects to the sign in page for unauthenticated users' do
      get :search, search_term: family_guy.title
      response.should redirect_to sign_in_path
    end
  end

end