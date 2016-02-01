# spec/features/auth_spec.rb

require 'spec_helper'
require 'rails_helper'

feature "the signup process" do

  scenario "has a new user page" do
    visit 'users/new'
    expect(page).to have_content "Sign Up"
  end

  feature "signing up a user" do

    before(:each) do
      sign_up("testing_username")
    end

    it "shows username on the homepage after signup" do
      expect(page).to have_content "testing_username"
    end
  end
end

feature "logging in" do

  before(:each) do
    sign_up("testing_username")
    click_button 'Log Out'
    sign_in("testing_username")
  end
  it "shows username on the homepage after login" do
    expect(page).to have_content "testing_username"
  end

end

feature "logging out" do

  before(:each) do
    sign_up("testing_username")
    click_button 'Log Out'
  end

  it "begins with logged out state" do
    expect(page).to have_link "Sign In"
    expect(page).to have_link "Sign Up"
  end
  it "doesn't show username on the homepage after logout" do
    sign_in("testing_username")
    click_button 'Log Out'

    expect(page).to have_no_content "testing_username"
  end
end
