class CreateUserIdentitiesIdTokens < ActiveRecord::Migration
  def change
    create_table :user_identities_id_tokens do |t|
      t.string     :key
      t.references :identity, :polymorphic => true

      t.timestamps
    end
    add_index :user_identities_id_tokens, :identity_id
    add_index :user_identities_id_tokens, :key
  end
end
