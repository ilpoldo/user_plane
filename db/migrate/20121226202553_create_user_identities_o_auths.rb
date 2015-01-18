class CreateUserIdentitiesOAuths < ActiveRecord::Migration
  def change
    create_table :user_identities_o_auths do |t|
      t.references :account
      t.string     :type
      t.string     :uid
      t.string     :handle

      t.timestamps
    end
    add_index :user_identities_o_auths, :handle
    add_index :user_identities_o_auths, :type
  end
end
