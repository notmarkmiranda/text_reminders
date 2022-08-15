class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :phone_number, null: false
      t.string :verification
      t.datetime :verification_expiration

      t.timestamps
    end
  end
end
