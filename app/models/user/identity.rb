module User

  class Identity < ActiveRecord::Base
    self.abstract_class = true

    def serialize
      # TODO: create the token when it's missing
      self.id_token.key
    end

    def self.deserialize id_token
      token = Identities::IdToken.find_by_key(id_token) or raise ActiveRecord::RecordNotFound
      token.identity
    end

    def self.deserialize! id_token
      identity = deserialize(id_token)
      if identity
        raise User::AccountSuspended unless identity.account.suspensions.empty?
      end
      identity
    end

    before_validation do
      self.build_id_token
    end

  end

end