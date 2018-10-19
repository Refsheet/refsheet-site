class Marketplace::TestController < MarketplaceController
  def show
    @listings = Item.market_order
    @characters = Character.for_sale.order('items.created_at')
  end

  def sell
    @characters = current_user.characters
  end

  def cart
  end

  def setup
    @seller = current_user.seller || StripeSeller.new
  end

  def orders
    @orders = current_user.orders
  end

  def create_listing
    listing_params = params.require(:item)
                         .permit(:character_id,
                                 :amount)
                         .merge(user: current_user,
                                seller: current_user.seller)

    @listing = Marketplace::Items::CharacterListing.new listing_params

    if @listing.save
      redirect_to marketplace_root_path
    else
      flash.now[:error] = @listing.errors.full_messages.to_sentence
      sell
      render 'sell'
    end
  end

  def destroy_listing
    @listing = Item.find params[:id]
    @listing&.expire! if @listing.seller_user_id == current_user.id

    redirect_to marketplace_sell_path, flash: {
        notice: 'Listing removed.'
    }
  end

  def create_cart
    persist_cart!
    @item = current_cart.add_item params[:item_id]

    if @item.valid?
      redirect_to marketplace_cart_path
    else
      flash.now[:error] = @item.errors.full_messages.to_sentence
      show
      render 'show'
    end
  end

  def destroy_cart
    if (@line = OrderItem.find_by id: params[:id])
      @line.destroy! if @line.order_id == current_cart.id

      redirect_to marketplace_cart_path, flash: {
          notice: 'Listing removed.'
      }
    else
      redirect_to :back, flash: { error: 'Can\'t find order item.' }
    end
  end

  def create_payment
    stripe_params = params.permit(:card_token)

    stripe_payment = StripePayment.new card_token: stripe_params['card_token'],
                                       order: current_cart

    if stripe_payment.execute!
      reset_cart!

      redirect_to marketplace_orders_path, flash: {
          notice: 'Order complete.'
      }
    else
      redirect_to marketplace_cart_path, flash: {
          error: stripe_payment&.failure_reason || 'Unable to execute payment. See logs.'
      }
    end
  end

  def create_seller
    seller_params = params.require(:seller)
                        .permit(:first_name,
                                :last_name,
                                :dob)
                        .merge(user: current_user,
                               processor_type: 'custom',
                               tos_acceptance_ip: request.remote_addr,
                               tos_acceptance_date: Time.zone.now)

    @seller = StripeSeller.new seller_params

    if @seller.save
      redirect_to marketplace_setup_path, flash: {
          notice: 'Congratulations, you are now a seller!'
      }
    else
      render 'setup'
    end
  end

  def create_bank_account
    acct_params = params.permit(:bank_account_token)
                        .merge(user: current_user)

    @bank_account = StripeBankAccount.new acct_params

    if @bank_account.save
      redirect_to marketplace_setup_path, flash: {
          notice: 'Bank account added.'
      }
    else
      flash.now[:error] = @bank_account.errors.full_messages.to_sentence
      render 'setup'
    end
  end
end
