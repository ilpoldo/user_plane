require 'active_model/validations'

module UserPlane
  class FreshValidator < ActiveModel::Validator
    def validate(record)
      record.errors.add(:created_at, 'has expired') if record.stale?
    end
  end
end