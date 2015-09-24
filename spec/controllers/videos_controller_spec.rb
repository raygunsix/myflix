require 'spec_helper'

describe VideosController do
  describe 'GET show' do

    before(:each) do
      user = User.create(email: 'testxx@example.com', password: 'test', full_name: 'Bob')
      session[:user_id] = user.id
      @family_guy = Video.create(title: 'Family Guy', description: 'A funny show')
    end

    it 'sets the @video instance variable' do
      get :show, id: @family_guy.id
      assigns(:video).should == Video.first
    end

    it 'renders the show template' do
      get :show, id: @family_guy.id
      response.should render_template :show
    end

    after(:each) do
      session[:user_id] = nil
    end
  end

end