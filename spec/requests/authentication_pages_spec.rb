require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_selector('title', text: 'Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before { visit root_path }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do 
        sign_in user 
      end

      it { should have_link('Sign out', href: signout_path) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end
      end

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",  with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end 

        describe "after signing in" do

          it "should render the desired protected page" do
            page.should have_selector('title', text: 'Settings')
          end
        end
      end

      describe "in the Restaurants controller" do
        let(:restaurant) { FactoryGirl.create(:restaurant) }

        describe "visiting the new page" do
          before { visit new_restaurant_path(restaurant) }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "submitting to the create action" do
          before { post restaurants_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the edit page" do
          before { visit edit_restaurant_path(restaurant) }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "submitting to the update action" do
          before { put restaurant_path(restaurant) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete restaurant_path(restaurant) }
          specify { response.should redirect_to(signin_path) }
        end
      end
    end

    describe "as wrong user" do
      let(:restaurant) { FactoryGirl.create(:restaurant) }
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: 'Settings') }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end

      describe "visiting Restaurants#edit page" do
        before { visit edit_restaurant_path(restaurant) }
        it { should_not have_selector('title', text: 'Edit restaurant') }
      end
    end

    describe "as non-admin user" do
      let(:restaurant) { FactoryGirl.create(:restaurant) }
      let(:non_admin) { FactoryGirl.create(:user) } 
      before { sign_in non_admin }

      describe "submitting a PUT request to the Restaurants#update action" do
        before { put restaurant_path(restaurant) }
        specify { response.should redirect_to(restaurants_path) }
      end

      describe "submitting a DELETE request to the Restaurants#destroy 
               action" do
        before { delete restaurant_path(restaurants_path) }
        specify { response.should redirect_to(restaurants_path) }
      end
    end
  end
end
