class Ticket < ActiveRecord::Base
  belongs_to :project
  belongs_to :author, class_name: "User"

  validates :name, presence: true
  validates :description, presence: true, length: { minimum: 10 }
end
