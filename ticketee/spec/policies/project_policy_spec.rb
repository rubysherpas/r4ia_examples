require "rails_helper"

describe ProjectPolicy do

  let(:user) { User.new }

  subject { ProjectPolicy }

  context "policy_scope" do
    subject { Pundit.policy_scope(user, Project) }

    let!(:project) { FactoryGirl.create :project }
    let(:user) { FactoryGirl.create :user }

    it "is empty for anonymous users" do
      expect(Pundit.policy_scope(nil, Project)).to be_empty
    end

    it "includes projects a user is allowed to view" do
      assign_role!(user, :viewer, project)
      expect(subject).to include(project)
    end

    it "doesn't include projects a user is not allowed to view" do
      expect(subject).to be_empty
    end

    it "returns all projects for admins" do
      user.admin = true
      expect(subject).to include(project)
    end
  end

  context "permissions" do
    subject { ProjectPolicy.new(user, project) }

    let(:user) { FactoryGirl.create(:user) }
    let(:project) { FactoryGirl.create(:project) }

    context "for anonymous users" do
      let(:user) { nil }

      it { should_not permit_action :show }
      it { should_not permit_action :update }
    end

    context "for viewers of the project" do
      before { assign_role!(user, :viewer, project) }

      it { should permit_action :show }
      it { should_not permit_action :update }
    end

    context "for editors of the project" do
      before { assign_role!(user, :editor, project) }

      it { should permit_action :show }
      it { should_not permit_action :update }
    end

    context "for managers of the project" do
      before { assign_role!(user, :manager, project) }

      it { should permit_action :show }
      it { should permit_action :update }
    end

    context "for managers of other projects" do
      before do
        assign_role!(user, :manager, FactoryGirl.create(:project))
      end

      it { should_not permit_action :show }
      it { should_not permit_action :update }
    end

    context "for administrators" do
      let(:user) { FactoryGirl.create :user, :admin }

      it { should permit_action :show }
      it { should permit_action :update }
    end
  end
end
