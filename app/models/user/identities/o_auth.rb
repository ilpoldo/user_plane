module User

  class Identities::OAuth < Identity
    extend SupportSegment::StiHelpers

    belongs_to      :account,  class_name: 'User::Account'
    has_one         :id_token, as: :identity

  end
  
end
