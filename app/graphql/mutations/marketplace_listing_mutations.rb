class MarketplaceListingMutations < ApplicationMutation
  action :create do
    type Types::MarketplaceListingType

    argument :characterId, !types.ID
    argument :amount, !types.Int
  end

  def create
    @character = Character.find_by!(guid: params[:characterId])

    listing_params = params.permit(:amount).merge(
        character: @character,
        user: current_user,
        seller: current_user.seller
    )

    @listing = Marketplace::Items::CharacterListing.new listing_params
    authorize! @listing

    @listing.save
    @listing
  end
end
