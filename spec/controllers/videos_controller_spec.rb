require 'spec_helper'

describe VideosController do

  before(:each) do
    user = User.create(email: 'testxx@example.com', password: 'test', full_name: 'Bob')
    session[:user_id] = user.id
    @family_guy = Video.create(title: 'Family Guy', description: 'A funny show')
  end

  describe 'GET show' do
    it 'sets the @video instance variable' do
      get :show, id: @family_guy.id
      assigns(:video).should == Video.first
    end

    it 'renders the show template' do
      get :show, id: @family_guy.id
      response.should render_template :show
    end
  end

  describe "GET search" do
    it 'sets the @results instance variable' do
      get :search, search_term: @family_guy.title
      assigns(:results).should include Video.first
    end

    it 'renders the search template' do
      get :search, search_term: @family_guy.title
      response.should render_template :search
    end
  end

  after(:each) do
    session[:user_id] = nil
  end
end