class FavouritesController < ApplicationController
    before_action :logged_in_user

    def create
        micropost = Micropost.find(params[:micropost_id])
        current_account.favourite(micropost)
        redirect_to root_url
    end
    
    def destroy
        micropost = Favourite.find(params[:id]).micropost
        current_account.unfavourite(micropost)
        redirect_to root_url
    end
end
