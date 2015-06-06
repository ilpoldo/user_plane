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

end