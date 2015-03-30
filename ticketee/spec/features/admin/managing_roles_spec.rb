require "rails_helper"

RSpec.feature "Admins can manage a user's roles" do
  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:user) { FactoryGirl.create(:user) }

  let!(:ie) { FactoryGirl.create(:project, name: "Internet Explorer") }
  let!(:st3) { FactoryGirl.create(:project, name: "Sublime Text 3") }

  before do
    login_as(admin)
  end

  scenario "when assigning roles to an existing user" do
    visit admin_user_path(user)
    click_link "Edit User"

    select "Viewer", from: "Internet Explorer"
    select "Manager", from: "Sublime Text 3"

    click_button "Update User"
    expect(page).to have_content "User has been updated"

    click_link user.email
    expect(page).to have_content "Internet Explorer: Viewer"
    expect(page).to have_content "Sublime Text 3: Manager"
  end
end
