require 'active_support/concern'

module TokenSegment
  extend ActiveSupport::Concern

  module ClassMethods
    
    def has_token(attribute, options={})
      
      validate attribute, uniqueness: true

      if options[:expires_in]
        scope :stale, -> {unscoped.where(:created_at.gt => life_span.ago)}
        default_scope -> {where(:created_at.gt => life_span.ago)}
      end

      before_validation do
        if block_given?
          make_token attribute, yield
        else
          make_token attribute
        end
      end
    end

  end

private

  def make_token(attribute, token_string = nil)
    string_to_hash = token_string || "#{self.class.name}-#{Time.now}-#{rand}-#{self.id}"
    new_attributes = {attribute => Digest::SHA1.hexdigest(string_to_hash)}
    self.assign_attributes new_attributes
  end

end
