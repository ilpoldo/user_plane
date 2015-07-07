module User
  class Identity < ActiveRecord::Base
    self.abstract_class = true

    def serialize
      # TODO: create the token when it's missing
      id_token.key
    end

    def self.deserialize id_token
      token = Identities::IdToken.find_by_key(id_token)
      token ? token.identity : nil
    end

    def self.deserialize! id_token
      identity = deserialize(id_token)
      if identity
        raise User::AccountSuspended unless identity.account.suspensions.empty?
        identity
      else
        raise ActiveRecord::RecordNotFound
      end
    end

  end
end