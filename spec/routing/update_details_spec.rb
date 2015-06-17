require 'spec_helper'
require 'shared_contexts/user'
require 'shared_contexts/routing'



describe "routest for UpdateDetails" do
  include_context 'user'
  include_context 'routing'

  context 'updating details' do
    
    subject :update_details do
      User::UpdateDetails.new
    end

    it "is routed" do
      path = polymorphic_path(User::UpdateDetails.new, action: :edit)
      passing_signed_in_constraint
      expect(get: path).to route_to('user/details#edit')
    end
  end


end