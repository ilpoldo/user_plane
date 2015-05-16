class CreateUserIdentitiesOAuths < ActiveRecord::Migration
  def change
    create_table :user_identities_o_auths do |t|
      t.references :account
      t.string     :provider
      t.string     :uid
      t.string     :handle

      t.timestamps
    end
  end
end
