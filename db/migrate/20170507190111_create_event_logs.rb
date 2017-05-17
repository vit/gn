class CreateEventLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :event_logs do |t|
      t.integer :loggable_id
      t.string :loggable_type
      t.string :state_old
      t.string :state_new
      t.string :event

      t.timestamps
    end
  end
end
