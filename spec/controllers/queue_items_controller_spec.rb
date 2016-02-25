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
    it 'redirects to the my queue page' do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      response.should redirect_to my_queue_path
    end
    it 'creates a queue item' do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      QueueItem.count.should == 1
    end
    it 'creates the queue item that is associated with the video' do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      QueueItem.first.video.should == video
    end
    it 'creates the queue item that is associated with the signed in user' do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      video = Fabricate(:video)
      post :create, video_id: video.id
      QueueItem.first.user.should == alice
    end
    it 'adds the video as the last item in the queue' do
      alice = Fabricate(:user)
      monk = Fabricate(:video)
      south_park = Fabricate(:video)
      session[:user_id] = alice.id
      Fabricate(:queue_item, video: monk, user: alice)
      post :create, video_id: south_park.id
      south_park_queue_item = QueueItem.where(video_id: south_park.id, user_id: alice.id).first
      south_park_queue_item.position.should == 2
    end
    it 'does not add the video to the queue twice' do
      alice = Fabricate(:user)
      monk = Fabricate(:video)
      session[:user_id] = alice.id
      Fabricate(:queue_item, video: monk, user: alice)
      post :create, video_id: monk.id
      alice.queue_items.count.should == 1
    end

    it 'redirects unauthenticated users to the sign in page' do
      post :create, video_id: 3
      response.should redirect_to sign_in_path
    end
  end

  describe 'DELETE destroy' do
    it 'redirects to the my queue page' do
      session[:user_id] = Fabricate(:user)
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      response.should redirect_to my_queue_path
    end
    it 'deletes the queue item' do
      alice = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: alice)
      session[:user_id] = alice.id
      delete :destroy, id: queue_item.id
      QueueItem.count.should == 0
    end
    it 'only deletes the queue item if it is owned by the current_user' do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      session[:user_id] = alice.id
      queue_item = Fabricate(:queue_item, user: bob)
      delete :destroy, id: queue_item.id
      QueueItem.count.should == 1
    end
    it 'redirects to the sign in page if the user is unauthenticated' do
      post :destroy, id: 3
      response.should redirect_to sign_in_path
    end
  end

end