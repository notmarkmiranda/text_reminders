class RemoveIntegerIdFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :integer_id
  end
end
