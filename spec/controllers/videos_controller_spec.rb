require 'spec_helper'

describe VideosController do

  describe 'GET show' do
    let(:video) { Fabricate(:video) }

    it 'sets the @video instance variable for authenticated users' do
      session[:user_id] = Fabricate(:user).id
      get :show, id: video.id
      assigns(:video).should == video
    end

    it 'redirects to the sign in page for unauthenticated users' do
      get :show, id: video.id
      response.should redirect_to sign_in_path
    end
  end

  describe "GET search" do
    let(:video) { Fabricate(:video) }

    it 'sets the @results instance variable for authenticated users' do
      session[:user_id] = Fabricate(:user).id
      get :search, search_term: video.title
      assigns(:results).should include video
    end

    it 'redirects to the sign in page for unauthenticated users' do
      get :search, search_term: video.title
      response.should redirect_to sign_in_path
    end
  end

end