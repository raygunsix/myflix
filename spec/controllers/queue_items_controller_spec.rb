require 'spec_helper'

describe QueueItemsController do
  describe 'GET index' do
    it 'sets @queue_items to the queue items of the logged in user' do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      queue_item1 = Fabricate(:queue_item, user: alice)
      queue_item2 = Fabricate(:queue_item, user: alice)
      get :index
      assigns(:queue_items).should match_array([queue_item1,queue_item2])
    end

    it 'redirects to the sign in page for unautheticated users' do
      get :index
      response.should redirect_to sign_in_path
    end
  end

  describe 'POST create' do

    context 'for authenticated users' do

      let(:alice) { Fabricate(:user) }
      before { session[:user_id] = alice.id }

      it 'redirects to the my queue page' do
        video = Fabricate(:video)
        post :create, video_id: video.id
        response.should redirect_to my_queue_path
      end
      it 'creates a queue item' do
        video = Fabricate(:video)
        post :create, video_id: video.id
        QueueItem.count.should == 1
      end
      it 'creates the queue item that is associated with the video' do
        video = Fabricate(:video)
        post :create, video_id: video.id
        QueueItem.first.video.should == video
      end
      it 'creates the queue item that is associated with the signed in user' do
        video = Fabricate(:video)
        post :create, video_id: video.id
        QueueItem.first.user.should == alice
      end
      it 'adds the video as the last item in the queue' do
        monk = Fabricate(:video)
        south_park = Fabricate(:video)
        Fabricate(:queue_item, video: monk, user: alice)
        post :create, video_id: south_park.id
        south_park_queue_item = QueueItem.where(video_id: south_park.id, user_id: alice.id).first
        south_park_queue_item.position.should == 2
      end
      it 'does not add the video to the queue twice' do
        monk = Fabricate(:video)
        Fabricate(:queue_item, video: monk, user: alice)
        post :create, video_id: monk.id
        alice.queue_items.count.should == 1
      end

    end

    context 'for unauthenticated users' do

      it 'redirects unauthenticated users to the sign in page' do
        post :create, video_id: 3
        response.should redirect_to sign_in_path
      end

    end
  end

  describe 'DELETE destroy' do

    context 'for authenticated users' do

      let(:alice) { Fabricate(:user) }
      before { session[:user_id] = alice.id }

      it 'redirects to the my queue page' do
        queue_item = Fabricate(:queue_item)
        delete :destroy, id: queue_item.id
        response.should redirect_to my_queue_path
      end
      it 'deletes the queue item' do
        queue_item = Fabricate(:queue_item, user: alice)
        delete :destroy, id: queue_item.id
        QueueItem.count.should == 0
      end
      it 'only deletes the queue item if it is owned by the current_user' do
        bob = Fabricate(:user)
        queue_item = Fabricate(:queue_item, user: bob)
        delete :destroy, id: queue_item.id
        QueueItem.count.should == 1
      end

    end

    context 'for unauthenticated users' do

      it 'redirects to the sign in page if the user is unauthenticated' do
        post :destroy, id: 3
        response.should redirect_to sign_in_path
      end

    end
  end

end