class CreateUserAccounts < ActiveRecord::Migration
  def change
    create_table :user_accounts do |t|
      t.string :name
      t.string :uid

      t.timestamps
    end
    add_index :user_accounts, :uid
  end
end
