class CreateUserIdentitiesEmailVerifications < ActiveRecord::Migration
  def change
    create_table :user_identities_email_verifications do |t|
      t.string :token
      t.string :type
      t.string :recipient
      t.references :email
      t.datetime   :spent_at

      t.timestamps
    end
    add_index :user_identities_email_verifications, :email_id
  end
end
