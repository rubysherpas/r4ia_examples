class Admin::ApplicationController < ApplicationController
  skip_after_action :verify_authorized, :verify_policy_scoped
  before_action :authorize_admin!

  def index
  end

  private

  def authorize_admin!
    authenticate_user!

    unless current_user.admin?
      redirect_to root_path, alert: "You must be an admin to do that."
    end
  end
end
