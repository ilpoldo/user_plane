class CreateUserSignUpInvitesStacks < ActiveRecord::Migration
  def change
    create_table :user_sign_up_invites_stacks do |t|
      t.references :owner, polymorphic: true
      t.integer :remaining_invites

      t.timestamps
    end
  end
end
