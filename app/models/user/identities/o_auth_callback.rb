module User::Identities
  class OAuthCallback
    extend ActiveModel::Naming

    attr_accessor :provider

    def initialize provider
      @provider = provider
    end

    def to_param
      provider
    end

    def to_model
      self
    end

    def persisted?
      true
    end

    def self.model_name
      ActiveModel::Name.new(self, nil, "OAuthCallback")
    end

  end
end