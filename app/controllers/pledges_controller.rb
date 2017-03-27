class PledgesController < ApplicationController
  respond_to :json

  def index
    @pledges = Patreon::Pledge.all
    respond_with @pledges, each_serializer: Patreon::PledgeSerializer
  end
end