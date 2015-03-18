class Project < ActiveRecord::Base
  has_many :tickets, dependent: :delete_all

  validates :name, presence: true
end