module User
  class UpdateDetails < Imperator::Command
    attribute :old_password
    
    validates_each :old_password, if: :password_changed? do |record, attr, value|
      record.errors.add(attr, 'is not correct') if BCrypt::Engine.hash_secret(value, record.password_salt)
    end
  end
end
