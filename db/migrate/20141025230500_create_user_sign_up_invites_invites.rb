class CreateUserSignUpInvitesInvites < ActiveRecord::Migration
  def change
    create_table :user_sign_up_invites_invites do |t|
      t.references :stack
      t.string :code
      t.string :recipient

      t.timestamps
    end
  end
end
