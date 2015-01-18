class CreateUserIdentitiesEmails < ActiveRecord::Migration
  def change
    create_table :user_identities_emails do |t|
      t.references :account
      t.string     :address
      t.string     :password_digest

      t.timestamps
    end
    add_index :user_identities_emails, :address
    add_index :user_identities_emails, :password_digest
  end
end
