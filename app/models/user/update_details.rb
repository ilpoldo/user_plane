module User
  class UpdateDetails < Imperator::Command
    attribute :account

    attribute :old_password

    delegate :password=, :password_confirmation=, to: :'account.email'

    validates_each :old_password, if: :password_changed? do |record, attr, value|
      record.errors.add(attr, 'is not correct') if record.account.email.authenticate(value)
    end

    def password_changed?
      @account.email ? @account.email.password_digest_changed? : false
    end

    action do
      ActiveRecord::Base.transaction do
        raise ActiveRecord::Rollback unless @account.save
      end
    end

  private

  end
end
