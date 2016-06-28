require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    it "sets @invitations to a new invitation" do
      set_current_user
      get :new
      assigns(:invitation).should be_new_record
      assigns(:invitation).should be_instance_of(Invitation)
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do
    after { ActionMailer::Base.deliveries.clear }

    context "with valid inputs" do
      before do
        set_current_user
        post :create, invitation: {
          recipient_name: "Bob",
          recipient_email: 'bob@example.com',
          message: 'Please join MyFlix!'
        }
      end

      it "redirects to the new invitation page" do
        response.should redirect_to new_invitation_path
      end

      it "creates a new invitation" do
        Invitation.count.should == 1
      end

      it "sends an email to the recipient" do
        ActionMailer::Base.deliveries.last.to.should == ['bob@example.com']
      end

      it "sets the flash success" do
        flash[:success].should be_present
      end
  end

    context "with invalid inputs" do
      before do
        set_current_user
        post :create, invitation: {recipient_name: "Bob"}
      end

      after { ActionMailer::Base.deliveries.clear }

      it "renders the new template" do
        response.should render_template :new
      end

      it "sets @invitation" do
        assigns(:invitation).should be_instance_of(Invitation)
      end

      it "does not create an invitation" do
        Invitation.count.should == 0
      end

      it "does not send an email" do
        ActionMailer::Base.deliveries.count.should == 0
      end

      it "sets the flash error" do
        flash[:error].should be_present
      end
    end

    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end
  end
end