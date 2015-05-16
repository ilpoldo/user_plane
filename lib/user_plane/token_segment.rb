require 'active_support/concern'

module TokenSegment
  extend ActiveSupport::Concern

  module ClassMethods
    
    def has_token(attribute, options={}, &block)
      # Generates a random token on a given attirubte at creation time.
      # optionally it can create it for every update of the record.

      validate attribute, uniqueness: true

      if life_span = options[:expires_in]
        scope :stale, -> {unscoped.where('created_at <= ?', life_span.ago)}
        scope :fresh, -> {where('created_at > ?', life_span.ago)}

        define_method :stale? do
          if new_record?
            false
          else
            created_at <= life_span.ago
          end
        end
      end

      define_method :"regenerate_#{attribute}" do
        if block_given?
          make_token attribute, instance_eval(&block)
        else
          make_token attribute
        end
      end  

      if regenerate_on = options[:regenerate_on]
        before_validation :"regenerate_#{attribute}", on: regenerate_on
      else
        before_validation :"regenerate_#{attribute}" 
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
