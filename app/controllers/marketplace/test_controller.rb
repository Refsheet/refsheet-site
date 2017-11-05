class Marketplace::TestController < MarketplaceController
  def show
  end

  def create_listing
    listing_params = params.require(:item).permit(:character_id, :amount).merge(seller: current_user)
    @listing = Marketplace::Items::CharacterListing.new listing_params

    if @listing.save
      redirect_to marketplace_root_path
    else
      flash.now[:error] = @listing.errors.full_messages.to_sentence
      render 'show'
    end
  end

  def create_cart
    persist_cart!

    if (@item = current_cart.add_item params[:item_id])
      redirect_to marketplace_root_path
    else
      flash.now[:error] = @item.errors.full_messages.to_sentence
      render 'show'
    end
  end

  def create_payment
    stripe_params = params.permit(:stripeEmail, :stripeToken)

    stripe_payment = StripePayment.new card_token: stripe_params['stripeToken'],
                                       order: current_cart

    if stripe_payment.execute!
      reset_cart!

      redirect_to marketplace_root_path, flash: {
          notice: 'Order complete.'
      }
    else
      redirect_to marketplace_root_path, flash: {
          error: 'Unable to execute payment. See logs.'
      }
    end
  end
end
