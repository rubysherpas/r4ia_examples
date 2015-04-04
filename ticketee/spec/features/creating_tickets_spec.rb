require "rails_helper"

RSpec.feature "Users can create new tickets" do
  let!(:state) { FactoryGirl.create :state, name: "New", default: true }
  let(:user) { FactoryGirl.create(:user) }

  before do
    login_as(user)
    project = FactoryGirl.create(:project, name: "Internet Explorer")
    assign_role!(user, :manager, project)

    visit project_path(project)
    click_link "New Ticket"
  end

  scenario "with valid attributes" do
    fill_in "Name", with: "Non-standards compliance"
    fill_in "Description", with: "My pages are ugly!"
    click_button "Create Ticket"

    expect(page).to have_content "Ticket has been created."
    expect(page).to have_content "State: New"
    within("#ticket") do
      expect(page).to have_content "Author: #{user.email}"
    end
  end

  scenario "when providing invalid attributes" do
    click_button "Create Ticket"

    expect(page).to have_content "Ticket has not been created."
    expect(page).to have_content "Name can't be blank"
    expect(page).to have_content "Description can't be blank"
  end

  scenario "with an invalid description" do
    fill_in "Name", with: "Non-standards compliance"
    fill_in "Description", with: "It sucks"
    click_button "Create Ticket"

    expect(page).to have_content "Ticket has not been created."
    expect(page).to have_content "Description is too short"
  end

  scenario "with multiple attachments", js: true do
    fill_in "Name", with: "Add documentation for blink tag"
    fill_in "Description", with: "Blink tag's speed attribute"

    attach_file "File #1", Rails.root.join("spec/fixtures/speed.txt")
    click_link "Add another file"

    attach_file "File #2", Rails.root.join("spec/fixtures/spin.txt")
    click_button "Create Ticket"

    expect(page).to have_content "Ticket has been created."

    within("#ticket .attachments") do
      expect(page).to have_content "speed.txt"
      expect(page).to have_content "spin.txt"
    end
  end

  scenario "persisting file uploads across form displays" do
    attach_file "File #1", "spec/fixtures/speed.txt"
    click_button "Create Ticket"

    fill_in "Name", with: "Add documentation for blink tag"
    fill_in "Description", with: "The blink tag has a speed attribute"
    click_button "Create Ticket"

    within("#ticket .attachments") do
      expect(page).to have_content "speed.txt"
    end
  end

  scenario "with associated tags" do
    fill_in "Name", with: "Non-standards compliance"
    fill_in "Description", with: "My pages are ugly!"
    fill_in "Tags", with: "browser visual"
    click_button "Create Ticket"

    expect(page).to have_content "Ticket has been created."
    within("#ticket #tags") do
      expect(page).to have_content "browser"
      expect(page).to have_content "visual"
    end
  end
end
