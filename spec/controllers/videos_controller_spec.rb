require 'spec_helper'

describe VideosController do
  before(:each) do
    session[:user_id] = Fabricate(:user).id
  end

  describe 'GET show' do
    let(:family_guy) { Fabricate(:video) }

    it 'sets the @video instance variable' do
      get :show, id: family_guy.id
      assigns(:video).should == Video.first
    end
  end

  describe "GET search" do
    let(:family_guy) { Fabricate(:video) }

    it 'sets the @results instance variable' do
      get :search, search_term: family_guy.title
      assigns(:results).should include Video.first
    end
  end

  after(:each) do
    session[:user_id] = nil
  end
end