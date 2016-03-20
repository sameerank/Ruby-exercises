require 'rails_helper'

feature "goal creation process" do
  before(:each) do
    sign_up("testing_username")
  end

  scenario "has a new goal link" do
    #visit goals_url
    expect(page).to have_link "New Goal"
  end

  feature "adding a new goal" do
    scenario "has a new goal page" do
      click_link "New Goal"
      expect(page).to have_content 'Create New Goal'
      expect(page).to have_content "Title"
      expect(page).to have_content 'Body'
    end

    before(:each) do
      click_link "New Goal"
      fill_in "Title", with: "New years resolution"
      fill_in 'Body', with: "Learn to program"
      check 'Make Goal Public'
      click_button 'Save Goal'
    end

    scenario "goal page displays new goal" do
      expect(page).to have_content 'New years resolution'
    end
    #Reading Goals Specs
    scenario "reading a goal" do
      click_link 'New years resolution'
      expect(page).to have_content 'Learn to program'
    end

    scenario "has a link to return to goals" do
      click_link 'New years resolution'
      expect(page).to have_content 'Return to Goals'
    end

    scenario "link on show goal returns user back to goals page" do
      click_link 'New years resolution'
      click_link 'Return to Goals'
      expect(page).to have_content 'Goals'
    end
  end
end


feature "edit and update goal" do
  before(:each) { create_goals }

  scenario "goal page has a link to edit goal" do
    expect(page).to have_link "Edit Goal"
  end

  feature "upon clicking edit goal" do
    before(:each) { click_link "Edit Goal" }

    scenario "edit goal link navigates to edit goal form" do
      expect(page).to have_content "Edit Goal"
      expect(page).to have_content "Title"
      expect(page).to have_content "Body"
    end

    scenario "edit goal form is pre-filled" do
      expect(find_field("Title").value).to eq('New years resolution')
      expect(find_field('Body').value).to eq('Learn to program')
    end

    scenario "shows errors if editing fails" do
      fill_in "Body", with: ""
      click_button "Update Goal"
      expect(page).to have_content "Edit Goal"
      expect(page).to have_content "Body can't be blank"
    end

    scenario "on successful update" do
      fill_in "Title", with: "New years curse"
      click_button "Update Goal"
      expect(page).to have_content "Goals"
      expect(page).to have_content "New years curse"
    end
  end
end

feature "destroy a goal" do
  before(:each) {create_goals}
  scenario "goal page has a link to delete goal" do
    expect(page).to have_link "Delete Goal"
  end

  scenario "deleting goal removes goal from goal list" do
    click_link "Delete Goal"
    expect(page).to have_no_content "New years resolution"
  end
end
