require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it "sets the @video to a new video" do
      set_current_admin
      get :new
      assigns(:video).should be_instance_of(Video)
      assigns(:video).should be_new_record
    end

    it "sets the flash error for regular users" do
      set_current_user
      get :new
      flash[:error].should be_present
    end

    it_behaves_like "requires admin" do
      let(:action) { post :new }
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do
    context "with authenticated admin user" do
      let(:category) { Fabricate(:category) }
      before { set_current_admin }

      context "with valid inputs" do
        it "creates a video" do
          post :create, video: { title: "Futurama", category_id: category.id, description: "Space travel." }
          category.videos.count.should == 1
        end

        it "redirects to the new video page" do
          post :create, video: { title: "Futurama", category_id: category.id, description: "Space travel." }
          response.should redirect_to new_admin_video_path
        end

        it "sets the flash success" do
          post :create, video: { title: "Futurama", category_id: category.id, description: "Space travel." }
          flash[:success].should be_present
        end
      end

      context "with invalid inputs" do
        it "does not create a new video" do
          post :create, video: { category_id: category.id, description: "Space travel."}
          category.videos.count.should == 0
        end

        it "renders the new template" do
          post :create, video: { category_id: category.id, description: "Space travel."}
          response.should render_template :new
        end

        it "sets @video" do
          post :create, video: { category_id: category.id, description: "Space travel."}
          assigns(:video).should be_present
        end

        it "sets the flash error" do
          post :create, video: { category_id: category.id, description: "Space travel."}
          flash[:error].should be_present
        end
      end
    end

    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end

    it_behaves_like "requires admin" do
      let(:action) { post :create }
    end
  end
end