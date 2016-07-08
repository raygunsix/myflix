require 'spec_helper'

describe UsersController do

  describe 'GET new' do
    it 'sets the @user instance variable' do
      get :new
      assigns(:user).should be_an_instance_of(User)
    end
  end

  describe 'POST create' do

    context 'with valid params' do
      let(:user) { Fabricate.attributes_for(:user) }
      before { post :create, user: user }

      it 'creates the user' do
        User.first.email.should == user['email']
      end

      it 'redirects to the sign in page' do
        response.should redirect_to sign_in_path
      end

      it "makes the user follow the inviter" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'bob@example.com')
        post :create, user: {email: 'bob@example.com', password: 'password', full_name: 'Bob Dylan'}, invitation_token: invitation.token
        bob = User.find_by(email: 'bob@example.com')
        bob.follows?(alice).should be true
      end

      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'bob@example.com')
        post :create, user: {email: 'bob@example.com', password: 'password', full_name: 'Bob Dylan'}, invitation_token: invitation.token
        bob = User.find_by(email: 'bob@example.com')
        alice.follows?(bob).should be true
      end

      it "expires the invitation after acceptance" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'bob@example.com')
        post :create, user: {email: 'bob@example.com', password: 'password', full_name: 'Bob Dylan'}, invitation_token: invitation.token
        invitation.reload.token.should be_nil
      end
    end

    context "with invalid params" do
      let(:user) { Fabricate.attributes_for(:user, email: nil) }
      before { post :create, user: user }

      it 'does not create the user' do
        User.first.should be_nil
      end

      it 'redirects to the new user page' do
        response.should render_template :new
      end
    end

    context 'sending email' do

      after { ActionMailer::Base.deliveries.clear }

      it 'sends email to the user with valid inputs' do
        post :create, user: { email: 'bob@example.com', password: 'password', full_name: 'Bob Smith' }
        ActionMailer::Base.deliveries.last.to.should == ['bob@example.com']
      end
      it 'sends email containing the users name with valid inputs' do
        post :create, user: { email: 'bob@example.com', password: 'password', full_name: 'Bob Smith' }
        ActionMailer::Base.deliveries.last.body.should include('Bob Smith')
      end
      it 'does not send email with invalid inputs' do
        post :create, user: { email: 'bob@xample.com' }
        ActionMailer::Base.deliveries.should be_empty
      end
    end

  end

  describe 'GET show' do
    it_behaves_like 'requires sign in' do
      let(:action) { get :show, id: 3 }
    end

    it 'sets @user' do
      set_current_user
      alice = Fabricate(:user)
      get :show, id: alice.id
      assigns(:user).should == alice
    end
  end

  describe "GET new_with_invitation_token" do
    context "with valid token" do
      let(:invitation) { Fabricate(:invitation) }
      before { get :new_with_invitation_token, token: invitation.token }

      it "renders :new user template" do
        response.should render_template :new
      end

      it "sets @user with recipient's email" do
        assigns(:user).email.should == invitation.recipient_email
      end

      it "sets @invitation_token" do
        assigns(:invitation_token).should == invitation.token
      end
    end

    context "with invalid token" do
      it "redirects to expired token page for invalid tokens" do
        get :new_with_invitation_token, token: 'invalidtoken'
        response.should redirect_to expired_token_path
      end
    end
  end
end