require 'spec_helper'
require 'shared_contexts/user'

describe "routes for SignIn" do
  include_context 'user'

  it "routes to the sign in page" do
    path = polymorphic_path([:new, User::SignIn.new])
    expect(get: path).to route_to('user/sign_ins#new')
  end

  it "routes when posting the sign in" do
    path = polymorphic_path([User::SignIn.new])
    expect(post: path).to route_to('user/sign_ins#create')
  end

  it "routes to the oauth request endpoint" do
    endpoint = User::Identities::OAuthEndpoint.new(:facebook)
    # TODO: Would be nice to use User::SignIn as the collection token, rather
    # than it's model name as a symbol.
    path = polymorphic_path([:user_sign_in, endpoint])

    expect(get: path).to route_to('user/sign_ins#oauth_request',
                                  on: :collection,
                                  provider: 'facebook')
  end

  it "routes to the oauth callback endpoint" do
    endpoint = User::Identities::OAuthEndpoint.new(:facebook)
    path = polymorphic_path([:user_sign_in, endpoint], action: :edit)
    expect(get: path).to route_to('user/sign_ins#oauth_callback',
                                  on: :collection,
                                  provider: 'facebook')
  end

end