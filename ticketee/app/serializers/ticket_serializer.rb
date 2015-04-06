class TicketSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :project_id, :created_at,
    :updated_at, :author_id

  has_one :state
end
