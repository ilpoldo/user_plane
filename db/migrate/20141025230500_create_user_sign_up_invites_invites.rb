class CreateUserSignUpInvitesInvites < ActiveRecord::Migration
  def change
    create_table :user_sign_up_invites_invites do |t|
      t.references :stack
      t.references :sender
      t.string :code
      t.string :recipient
      t.references :account

      t.timestamps
    end
  end
end
