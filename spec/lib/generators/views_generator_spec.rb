require "spec_helper"

describe UserPlane::Generators::ViewsGenerator, type: :generator do
  destination Dir.mktmpdir
  arguments %w(invites)

  before(:each) do
    prepare_destination
    puts ''
    puts '*******'
    puts run_generator
  end

  it "creates a test initializer" do
    assert_file 'app/views/user/invites/new.html.erb', /render ['"']form/
    assert_file 'app/views/user/invites/edit.html.erb'
  end
end
