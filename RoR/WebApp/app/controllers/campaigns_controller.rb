class CampaignsController < ApplicationController
def show
	@campaign = Campaign.find(params[:id])
end

def new
end

def create
@campaign = Campaign.new(campaign_params)

@campaign.save
redirect_to @campaign
end

private
	def campaign_params
		params.require(:campaign).permit(:title, :summary)
	end
end
