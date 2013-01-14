class SpotsController < ApplicationController
  before_filter :signed_in_user

  def create
    @restaurant = Restaurant.find(params[:spot][:restaurant_id])
    current_user.add_spot!(@restaurant)
    respond_to do |format|
      format.html { redirect_to restaurant_path(@restaurant) }
      format.js
    end
  end

  def destroy
    @spot = Spot.find(params[:id])
    @restaurant = Restaurant.find(@spot.restaurant.id)
    current_user.remove_spot!(@spot)
    respond_to do |format|
      format.html { redirect_to restaurant_path(@restaurant) }
      format.js
    end
  end
end
