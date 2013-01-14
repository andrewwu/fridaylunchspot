require 'spec_helper'

describe "Restaurant pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) } 
  let(:admin) { FactoryGirl.create(:admin) }
  let(:restaurant) { FactoryGirl.create(:restaurant) }

  describe "index" do

    describe "as a non-admin user" do
      before do
        FactoryGirl.create(:restaurant) 
        sign_in user
        visit restaurants_path
      end
      it { should have_selector('title', text: 'Restaurants') }
      it { should_not have_link('delete') }
      it { should_not have_link('edit') }

      describe "add/remove spot buttons" do
        let(:restaurant) { FactoryGirl.create(:restaurant) } 
        before do
          visit restaurant_path(restaurant)
        end

        describe" adding a spot" do
          it "should increment the user spot count" do
            expect do
              click_button "Add spot"
            end.to change(user.spots, :count).by(1)
          end
        end

        describe "toggling the button" do
          before { click_button "Add spot" }
          it { should have_selector('input', value: 'Remove spot') }
        end

        describe "removing a spot" do
          before do
            user.add_spot!(restaurant)
            visit restaurant_path(restaurant)
          end

          it "should decrement the user spot count" do
            expect do
              click_button "Remove spot"
            end.to change(user.spots, :count).by(-1)
          end
        end
      end
    end

    describe "as an admin user" do
      before do
        FactoryGirl.create(:restaurant) 
        sign_in admin
        visit restaurants_path
      end
      it { should have_selector('title', text: 'Restaurants') }
      it { should have_link('edit') }
      it { should have_link('delete') }
    end
  end

  describe "add" do
    let(:submit) { "Add restaurant" }
    before do
      sign_in user
      visit new_restaurant_path
    end

    describe "with invalid information" do

      it "should not add a restaurant" do
        expect { click_button submit }.not_to change(Restaurant, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_selector('h1', text: 'Add a restaurant') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      describe "as a non-admin user" do
        before do
          fill_in "Name",     with: "Example Restaurant"
          fill_in "Address",  with: "123 Main St."
          fill_in "City",     with: "Hayward" 
          fill_in "State",    with: "CA"
          fill_in "Zip",      with: "94544"
          fill_in "Phone",    with: "(510)123-4567"
        end

        it { should_not have_content('Approved') }

        it "should add an unapproved restaurant" do
          expect { click_button submit }.to change(Restaurant, :count).by(1)
          Restaurant.last.approved.should be_false
        end
      end

      describe "as an admin user" do

        it { should have_content('Approved') }

        before do
          sign_in admin
          visit new_restaurant_path
          fill_in "Name",     with: "Example Restaurant"
          fill_in "Address",  with: "123 Main St."
          fill_in "City",     with: "Hayward" 
          fill_in "State",    with: "CA"
          fill_in "Zip",      with: "94544"
          fill_in "Phone",    with: "(510)123-4567"
          check("Approved") 
        end

        it "should add an approved restaurant" do
          expect { click_button submit }.to change(Restaurant, :count).by(1)
          Restaurant.last.approved.should be_true
        end
      end
    end
  end

  describe "edit" do
    before do
      sign_in admin
      visit edit_restaurant_path(restaurant)
    end

    describe "page" do
      it { should have_selector('h1',    text: "Edit restaurant") }
      it { should have_selector('title', text: "Edit restaurant") }
    end

    describe "with valid information" do
      let(:new_name) { "New Restaurant Name" }
      before do
        fill_in "Name", with: new_name
        click_button "Save changes"
      end

      it { should have_selector('div.alert.alert-success', 
                              text: "Restaurant updated!") }
      specify { restaurant.reload.name.should == new_name }
    end
  end

  describe "destroy" do
    before do
      FactoryGirl.create(:restaurant)
      sign_in admin
      visit restaurants_path
    end

    it "should delete a restaurant" do
      expect { click_link "delete" }.to change(Restaurant, :count).by(-1)
    end
  end
end
