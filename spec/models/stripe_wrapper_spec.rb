require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      it "makes a successful charge", :vcr do
        Stripe.api_key = ENV['STRIPE_API_KEY']
        stripeToken = Stripe::Token.create(
          :card => {
            :number => "4242424242424242",
            :exp_month => 6,
            :exp_year => 2018,
            :cvc => "314"
          },
        ).id

        response = StripeWrapper::Charge.create(
          amount: 999,
          source: stripeToken,
          description: "a valid charge"
          )

        expect(response).to be_successful
      end

      it "makes a card declined charge", :vcr do
        Stripe.api_key = ENV['STRIPE_API_KEY']
        stripeToken = Stripe::Token.create(
          :card => {
            :number => "4000000000000002",
            :exp_month => 3,
            :exp_year => 2018,
            :cvc => "314"
          },
        ).id

        response = StripeWrapper::Charge.create(
          amount: 999,
          source: stripeToken,
          description: "an invalid charge"
          )

        expect(response).not_to be_successful
      end

      it "returns the error message for the declined charges", :vcr do
        Stripe.api_key = ENV['STRIPE_API_KEY']
        stripeToken = Stripe::Token.create(
          :card => {
            :number => "4000000000000002",
            :exp_month => 3,
            :exp_year => 2018,
            :cvc => "314"
          },
        ).id

        response = StripeWrapper::Charge.create(
          amount: 999,
          source: stripeToken,
          description: "an invalid charge"
          )

        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end
end