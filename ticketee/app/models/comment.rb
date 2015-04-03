class Comment < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :author, class_name: "User"

  validates :text, presence: true

  delegate :project, to: :ticket

  scope :persisted, lambda { where.not(id: nil) }
end
