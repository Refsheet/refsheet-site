class PledgesController < ApplicationController
  def index
    @pledges = Patreon::Pledge.all
    respond_with @pledges, each_serializer: Patreon::PledgeSerializer
  end
end
