class Ticket < ActiveRecord::Base
  belongs_to :project
  belongs_to :author, class_name: "User"
  belongs_to :state
  has_many :attachments, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :tags, uniq: true
  has_and_belongs_to_many :watchers, join_table: "ticket_watchers",
    class_name: "User", uniq: true

  attr_accessor :tag_names

  validates :name, presence: true
  validates :description, presence: true, length: { minimum: 10 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  before_create :assign_default_state
  after_create :author_watches_me

  searcher do
    label :tag, from: :tags, field: "name"
    label :state, from: :state, field: "name"
  end

  def tag_names=(names)
    @tag_names = names
    names.split.each do |name|
      self.tags << Tag.find_or_initialize_by(name: name)
    end
  end

  private

  def author_watches_me
    if author.present? && !self.watchers.include?(author)
      self.watchers << author
    end
  end

  def assign_default_state
    self.state ||= State.default
  end
end
