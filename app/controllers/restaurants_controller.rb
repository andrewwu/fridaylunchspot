class RestaurantsController < ApplicationController
  before_filter :signed_in_user, only: [:index, :show, :new, :create, :edit, 
                                        :update, :destroy]
  before_filter :admin_user, only: [:edit, :update, :destroy]

  def index
    @restaurants = Restaurant.where(approved: true)
    @unapproved_restaurants = Restaurant.where(approved: false)
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(params[:restaurant])
    @restaurant.approved = false if !current_user.admin?

    if @restaurant.save
      flash[:success] = current_user.admin? ? "Restaurant created!" : 
            "Thanks for the submission! Our team will be reviewing it shortly."
      redirect_to restaurants_path
    else
      render 'new'
    end
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.update_attributes(params[:restaurant])
      flash[:success] = "Restaurant updated!"
      redirect_to restaurants_path
    else
      render 'edit'
    end
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    @restaurant.destroy
    redirect_to restaurants_path
  end

  private
    
    def admin_user
      redirect_to(restaurants_path) unless current_user.admin?
    end
end
