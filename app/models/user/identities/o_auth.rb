module User
  module Identities

    # The class methods have been moved into a separate module so that they
    # could be added as association extensions if necessary.
    module OauthBuildCreateAndFind
      attr_accessor :provider_name

      def initialize_from_omniauth ominauth_data
        identity_provider = provider_from_ominauth(ominauth_data)
        identity_provider.new(ominauth_data: ominauth_data)
      end

      def find_from_omniauth ominauth_data
        identity_provider = provider_from_ominauth(ominauth_data)
        identity_provider.find_by(uid: ominauth_data['uid'])
      end

      def find_or_initialize_from_omniauth ominauth_data
        find_from_omniauth(ominauth_data) || initialize_from_omniauth(ominauth_data)
      end

    private
      def provider_from_ominauth ominauth_data
        provider_class = class_from_provider_name(ominauth_data[:provider])
        (current_scope || self).where(provider: provider_class)
      end

      def class_from_provider_name provider_name
        # TODO: build an unrecognized provider and have it caught by validations
        if_not_found = -> {raise Exception('Unknown oauth provider')}
        descendants.detect(if_not_found) do |p|
          p.provider_name == provider_name
        end
      end

    end

    class OAuth < Identity
      # Base class for omniauth-based user authentication

      self.inheritance_column = :provider
      include SupportSegment::StiHelpers
      extend OauthBuildCreateAndFind

      belongs_to      :account,  class_name: 'User::Account'
      has_one         :id_token, as: :identity

      validates :uid, presence: true,
                      uniqueness: {scope: :provider}

      before_validation do
        self.build_id_token
      end

      def ominauth_data= new_ominauth_data
        self.uid = new_ominauth_data[:uid]
        self.handle = new_ominauth_data[:info][:name]
      end
    end

  end
end
