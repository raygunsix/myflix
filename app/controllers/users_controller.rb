class UsersController < ApplicationController
  before_action :require_user, :only => [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(post_params)
    if @user.save
      handle_invitation
      Stripe.api_key = ENV['STRIPE_API_KEY']
      if params[:stripeToken]
        begin
          @amount = 999
          charge = Stripe::Charge.create(
            :source      => params[:stripeToken],
            :amount      => @amount,
            :description => 'MyFlix sign up charge',
            :currency    => 'usd'
          )
        rescue Stripe::CardError => e
          flash[:error] = e.message
        end
      end
      AppMailer.send_welcome_email(@user).deliver
      flash[:notice] = 'You have successfully regsitered!'
      redirect_to sign_in_path
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def new_with_invitation_token
    invitation = Invitation.find_by(token: params[:token])
    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path
    end
  end

  private

  def post_params
    params.require(:user).permit(:email, :password, :full_name)
  end

 def handle_invitation
    if params[:invitation_token].present?
      invitation = Invitation.find_by(token: params[:invitation_token])
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end
  end

end