# == Schema Information
#
# Table name: restaurants
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  address1   :string(255)
#  address2   :string(255)
#  city       :string(255)
#  state      :string(255)
#  zip        :string(255)
#  phone      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Restaurant do
  before { @restaurant = Restaurant.new(name: "Example Restaurant",
                                        address1: "123 Main St.", address2: "", 
                                        city: "Hayward", state: "CA", 
                                        zip: "94544", phone: "(510)123-4567" )}

  subject { @restaurant }

  it { should respond_to(:name) }
  it { should respond_to(:address1) }
  it { should respond_to(:address2) }
  it { should respond_to(:city) }
  it { should respond_to(:state) }
  it { should respond_to(:zip) }
  it { should respond_to(:phone) }
  it { should respond_to(:approved) }
  it { should respond_to(:users) }

  it { should be_valid } 
  it { should_not be_approved }

  describe "with approved attribute set to 'true'" do
    before do
      @restaurant.save!
      @restaurant.toggle!(:approved)
    end

    it { should be_approved }
  end

  describe "when name is not present" do
    before { @restaurant.name = " " }
    it { should_not be_valid }
  end

  describe "when address1 is not present" do
    before { @restaurant.address1 = " " }
    it { should_not be_valid }
  end

  describe "when city is not present" do
    before { @restaurant.city = " " }
    it { should_not be_valid }
  end

  describe "when state is not present" do
    before { @restaurant.state = " " }
    it { should_not be_valid }
  end

  describe "when zip is not present" do
    before { @restaurant.zip = " " }
    it { should_not be_valid }
  end

  describe "when phone is not present" do
    before { @restaurant.phone = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @restaurant.name = "a" * 256 }
    it { should_not be_valid }
  end

  describe "when address1 is too long" do
    before { @restaurant.address1 = "a" * 256 }
    it { should_not be_valid }
  end

  describe "when address2 is too long" do
    before { @restaurant.address2 = "a" * 256 }
    it { should_not be_valid }
  end

  describe "when city is too long" do
    before { @restaurant.city = "a" * 256 }
    it { should_not be_valid }
  end

  describe "when state is too long" do
    before { @restaurant.state = "a" * 256 }
    it { should_not be_valid }
  end

  describe "when zip is too long" do
    before { @restaurant.zip = "a" * 256 }
    it { should_not be_valid }
  end

  describe "when phone is too long" do
    before { @restaurant.phone = "a" * 256 }
    it { should_not be_valid }
  end
end
