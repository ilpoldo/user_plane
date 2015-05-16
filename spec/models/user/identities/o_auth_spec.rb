require 'spec_helper'
require 'shared_contexts/user'

describe User::Identities::OAuth do
  include_context 'user'

  it 'creates the identity from oauth data' do
    oauth_identity = described_class.find_or_build_from_omniauth(facebook_oauth_data)

    expect(oauth_identity).to be_a(User::Identities::Facebook)
  end
end
