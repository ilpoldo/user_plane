class User::Identities::IdToken < ActiveRecord::Base
  include TokenSegment

  belongs_to  :identity, polymorphic: true
  has_token   :key

end
