require "rails_helper"

RSpec.feature "Users can watch and unwatch tickets" do
  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project) }
  let(:ticket) do
    FactoryGirl.create(:ticket, project: project, author: user)
  end

  before do
    assign_role!(user, "viewer", project)
    login_as(user)
    visit project_ticket_path(project, ticket)
  end

  scenario "successfully" do
    within("#watchers") do
      expect(page).to have_content user.email
    end

    click_link "Unwatch"
    expect(page).to have_content "You are no longer watching this " +
      "ticket."

    within("#watchers") do
      expect(page).to_not have_content user.email
    end

    click_link "Watch"
    expect(page).to have_content "You are now watching this ticket."

    within("#watchers") do
      expect(page).to have_content user.email
    end
  end
end
