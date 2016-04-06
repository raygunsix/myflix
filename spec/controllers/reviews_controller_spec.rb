require 'spec_helper'

describe ReviewsController do
  describe 'POST create' do

    let(:video) { Fabricate(:video) }

    context 'with authenticated users' do

      let(:current_user) { Fabricate(:user) }
      before { set_current_user(current_user) }

      context 'with valid inputs' do

        let(:review_attributes) { Fabricate.attributes_for(:review) }

        before do
          post :create, review: review_attributes, video_id: video.id
        end

        it 'redirects to the video show page' do
          response.should redirect_to video
        end
        it 'creates a review' do
          Review.count.should == 1
        end
        it 'creates a review this is associated with a video' do
          Review.first.video.should == video
        end
        it 'creates a review this is associated with the signed in user' do
          Review.first.user.should == current_user
        end

      end

      context 'with invalid inputs' do

        it 'does not create a review' do
          post :create, review: {rating: 1}, video_id: video.id
          Review.count.should == 0
        end
        it 'renders the videos/show template' do
          post :create, review: {rating: 1}, video_id: video.id
          response.should render_template 'videos/show'
        end
        it 'sets the @video instance variable' do
          post :create, review: {rating: 1}, video_id: video.id
          assigns(:video).should == video
        end
        it 'sets the @reviews instance variable' do
          review = Fabricate(:review, video: video)
          post :create, review: {rating: 1}, video_id: video.id
          assigns(:reviews).should match_array([review])
        end
      end

    end
    context 'with unauthenticated users' do
      it_behaves_like 'requires sign in' do
        let(:action) { post :create, review: Fabricate.attributes_for(:review), video_id: video.id }
      end
    end
  end
end