class CreateReminders < ActiveRecord::Migration[7.0]
  def change
    create_table :reminders do |t|
      t.string :text, null: false
      t.timestamp :run_at, null: true

      t.timestamps null: false
    end
  end
end
