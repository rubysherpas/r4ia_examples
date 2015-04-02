class RemoveAttachmentFromTickets < ActiveRecord::Migration
  def change
    remove_column :tickets, :attachment, :string
  end
end
