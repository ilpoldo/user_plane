class CreateUserSuspensions < ActiveRecord::Migration
  def change
    create_table :user_suspensions do |t|
      t.string :message
      t.references :issuer
      t.references :foo

      t.timestamps
    end
    add_index :user_suspensions, :issuer_id
    add_index :user_suspensions, :foo_id
  end
end
