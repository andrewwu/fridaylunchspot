require 'spec_helper'

describe Spot do

  let(:user) { FactoryGirl.create(:user) }
  let(:restaurant) { FactoryGirl.create(:restaurant) }
  let(:spot) { user.spots.build(restaurant_id: restaurant.id) } 

  subject { spot }

  it { should be_valid }

  describe "when user id is not present" do
    before { spot.user_id = nil }
    it { should_not be_valid }
  end

  describe "when restaurant id is not present" do
    before { spot.restaurant_id = nil }
    it { should_not be_valid }
  end
end
