module User
  module Identities

    # The class methods have been moved into a separate module so that they
    # could be added as association extensions if necessary.
    module OauthBuildCreateAndFind

      def find_identity sign_in
        find_from_omniauth(sign_in[:oauth_data])
      end

      def build_identity sign_up
        identity = initialize_from_omniauth(sign_up[:oauth_data])
        sign_up.account.oauth_identities << identity

        identity
      end

      def initialize_from_omniauth ominauth_data
        identity_provider = provider_from_ominauth(ominauth_data)
        identity_provider.new(ominauth_data: ominauth_data)
      end

      def find_from_omniauth ominauth_data
        identity_provider = provider_from_ominauth(ominauth_data)
        identity_provider.find_by(uid: ominauth_data[:uid])
      end

      def find_or_build_from_omniauth ominauth_data
        find_from_omniauth(ominauth_data) || initialize_from_omniauth(ominauth_data)
      end

    private
      def provider_from_ominauth ominauth_data
        User::Identities.const_get(ominauth_data[:provider].camelize)
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

      def self.callback
        OAuthCallback.new(self.name.underscore.to_sym)
      end

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
