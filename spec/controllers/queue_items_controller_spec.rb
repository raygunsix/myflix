require 'spec_helper'

describe QueueItemsController do
  describe 'GET index' do
    it 'sets @queue_items to the queue items of the logged in user' do
      alice = Fabricate(:user)
      set_current_user(alice)
      queue_item1 = Fabricate(:queue_item, user: alice)
      queue_item2 = Fabricate(:queue_item, user: alice)
      get :index
      assigns(:queue_items).should match_array([queue_item1,queue_item2])
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :index }
    end
  end

  describe 'POST create' do

    context 'for authenticated users' do

      let(:alice) { Fabricate(:user) }
      before { set_current_user(alice) }

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
      it_behaves_like 'requires sign in' do
        let(:action) { post :create, video_id: 3 }
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
      it 'normalizes the remaining queue items' do
        queue_item1 = Fabricate(:queue_item, position: 1, user: alice)
        queue_item2 = Fabricate(:queue_item, position: 2, user: alice)
        delete :destroy, id: queue_item1.id
        QueueItem.first.position.should == 1
      end
    end

    context 'for unauthenticated users' do
      it_behaves_like 'requires sign in' do
        let(:action) { post :destroy, id: 3 }
      end
    end
  end

  describe 'POST update_queue' do

    context 'with valid inputs' do

      let(:alice) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, position: 1, user: alice, video: video) }
      let(:queue_item2) { Fabricate(:queue_item, position: 2, user: alice, video: video) }

      before { session[:user_id] = alice.id }

      it 'redirects to the my queue page' do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2},{id: queue_item2.id, position: 1}]
        response.should redirect_to my_queue_path
      end
      it 'reorders the queue items' do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2},{id: queue_item2.id, position: 1}]
        alice.queue_items.should == [queue_item2, queue_item1]
      end
      it 'normalizes the position numbers' do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3},{id: queue_item2.id, position: 2}]
        alice.queue_items.map(&:position).should == [1,2]
      end
    end

    context 'without valid inputs' do

      let(:alice) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, position: 1, user: alice, video: video) }
      let(:queue_item2) { Fabricate(:queue_item, position: 2, user: alice, video: video) }

      before { session[:user_id] = alice.id }

      it 'redirects to my queue page' do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4},{id: queue_item2.id, position: 2}]
        response.should redirect_to my_queue_path
      end
      it 'sets the flash error message' do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4},{id: queue_item2.id, position: 2}]
        flash[:error].should_not be_nil
      end

      it 'does not change the queue items' do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3},{id: queue_item2.id, position: 2.1}]
        queue_item1.reload.position.should == 1
      end
    end

    context 'with unauthenticated user' do
      it_behaves_like 'requires sign in' do
        let(:action) { post :update_queue, queue_items: [{id: 1, position: 3},{id: 2, position: 2}] }
      end
    end

    context 'with queue items that do not belong to the current user' do
      it 'does not change the queue items' do
        alice = Fabricate(:user)
        bob = Fabricate(:user)
        video = Fabricate(:video)
        session[:user_id] = alice.id
        queue_item1 = Fabricate(:queue_item, position: 1, user: bob, video: video)
        queue_item2 = Fabricate(:queue_item, position: 2, user: alice, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3},{id: queue_item2.id, position: 2}]
        queue_item1.reload.position.should == 1
      end
    end
  end

end