RSpec.shared_context 'routing' do

  # TODO: find a better way to mock being signed in
  def passing_signed_in_constraint
    expect_any_instance_of(SessionManager).to receive(:signed_in?).and_return(:true)
    allow_any_instance_of(SessionManager).to receive(:refresh!)
  end
end
