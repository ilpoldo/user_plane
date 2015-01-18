module User
  class Suspension < ActiveRecord::Base
    belongs_to      :issuer
    belongs_to      :account
    
  end
end
