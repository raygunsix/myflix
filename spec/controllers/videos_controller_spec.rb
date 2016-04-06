require 'spec_helper'

describe VideosController do

  describe 'GET show' do
    let(:video) { Fabricate(:video) }

    it 'sets the @video instance variable for authenticated users' do
      set_current_user
      get :show, id: video.id
      assigns(:video).should == video
    end

    it 'sets the @reviews instance variable for authenticated users' do
      set_current_user
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.id
      assigns(:reviews).should =~ [review1, review2]
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :show, id: video.id }
    end
  end

  describe "GET search" do
    let(:video) { Fabricate(:video) }

    it 'sets the @results instance variable for authenticated users' do
      session[:user_id] = Fabricate(:user).id
      get :search, search_term: video.title
      assigns(:results).should include video
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :search, search_term: video.title }
    end
  end

end