require "rails_helper"

RSpec.describe TicketsController, type: :controller do
  let(:project) { FactoryGirl.create(:project) }
  let(:user) { FactoryGirl.create(:user) }

  before :each do
    assign_role!(user, :editor, project)
    sign_in user
  end

  it "can create tickets, but not tag them" do
    post :create, ticket: { name: "New ticket!",
                            description: "Brand spankin' new",
                            tag_names: "these are tags" },
                  project_id: project.id
    expect(Ticket.last.tags).to be_empty
  end
end
