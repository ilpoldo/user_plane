require "spec_helper"
require 'generators/user_plane/views_generator'

describe UserPlane::Generators::ViewsGenerator, type: :generator do
  destination Dir.mktmpdir

  before(:each) do
    prepare_destination
    run_generator
  end

  it "creates a test initializer" do
    assert_file 'app/views/user/invites/new.html.erb', /form_for\(@send_sign_up_invite\)/
    assert_file 'app/views/user/invites/edit.html.erb', /form_for\(@sign_up_with_invite\)/
  end
end
