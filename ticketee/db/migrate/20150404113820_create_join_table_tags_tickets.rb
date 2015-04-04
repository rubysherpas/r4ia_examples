class CreateJoinTableTagsTickets < ActiveRecord::Migration
  def change
    create_join_table :tags, :tickets do |t|
      t.index [:tag_id, :ticket_id]
      t.index [:ticket_id, :tag_id]
    end
  end
end
