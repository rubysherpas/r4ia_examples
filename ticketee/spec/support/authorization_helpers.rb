module AuthorizationHelpers
  def assign_role!(user, role, project)
    Role.where(user: user, project: project).delete_all
    Role.create!(user: user, role: role, project: project)
  end
end

RSpec.configure do |c|
  c.include AuthorizationHelpers
end
