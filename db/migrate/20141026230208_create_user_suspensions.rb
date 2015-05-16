class CreateUserSuspensions < ActiveRecord::Migration
  def change
    create_table :user_suspensions do |t|
      t.string :message
      t.references :issuer
      t.references :account

      t.timestamps
    end
    add_index :user_suspensions, :issuer_id
    add_index :user_suspensions, :account_id
  end
end
