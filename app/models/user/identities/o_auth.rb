module User
  class Identities::OAuth < Identity
    # Base class for omniauth-based user authentication

    self.inheritance_column = :provider
    include SupportSegment::StiHelpers

    belongs_to      :account,  class_name: 'User::Account'
    has_one         :id_token, as: :identity

    validates :uid, presence: true,
                    uniqueness: {scope: :provider}

    class << self
      attr_accessor :provider_name

      def build_from_omniauth ominauth_data
        provider_class = find_identity_class_by_provider_name(ominauth_data[:provider])
        scoped_provider = self.current_scope.where(provider: provider_class)
        scoped_provider.build(ominauth_data: ominauth_data)
        #TODO: add find or create
      end

      def find_identity_class_by_provider_name provider_name
        descendants.detect {|p| p.provider_name == provider_name}
      end
    end

    def ominauth_data= new_ominauth_data
      self.uid = new_ominauth_data[:uid]
      self.handle = new_ominauth_data[:info][:name]
    end

  end
end
