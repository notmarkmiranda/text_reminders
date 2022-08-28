class AddJidToReminders < ActiveRecord::Migration[7.0]
  def change
    add_column :reminders, :jid, :string
  end
end
