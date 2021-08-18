class PaymentController < ApplicationController
  def create

    @listing = Listing.find(params[:listing_id])

    if ENV['RAILS_ENV'] == "development"
      root_path = "http://localhost:3000"
    else
      root_path = ENV['RAILS_ROOT_PATH']
    end

    #implement stripe code
    Stripe.api_key = Rails.application.credentials.dig(:stripe_api_key)
      session = Stripe::Checkout::Session.create({
        payment_method_types: ['card'],
        line_items: [{
          price_data: {
            currency: 'aud',
            product_data: {
              name: @listing.title,
            },
            unit_amount: @listing.price.to_i * 100,
          },
          quantity: 1,
        }],
        mode: 'payment',
        # These placeholder URLs will be replaced in a following step.
        success_url: "#{root_path}/listings/#{@listing.id}?checkout=success",
        cancel_url: "#{root_path}/payment/cancel",
      })
    
      redirect_to session.url
    end
  end

