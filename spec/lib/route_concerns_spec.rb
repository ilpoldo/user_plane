require 'spec_helper'

describe UserPlane::RouteConcerns::AbstractConcern do

  let (:mapper) {double()}
  before {allow(mapper).to receive(:namespace).and_yield}
  
  let :init_options do
    {module: 'baz'}
  end

  subject :a_resource_concern do
    class ConcreteConcern < described_class
      def build
        mapper.resource options(as: :foo)
      end
    end

    ConcreteConcern.new(init_options)
  end

  it 'combines options' do
    allow(mapper).to receive(:resource_scope?).and_return(true)
    expect(mapper).to receive(:resource).with(hash_including(as: :foo))
    a_resource_concern.call(mapper)
  end


  context 'concern-specific options' do
    subject :a_two_level_concern do
      class ConcreteConcern < described_class
        def build
          foo_controller = concern_options.delete(:controller)
          mapper.resource options
          mapper.resource options(as: :foo, to: "#{foo_controller}#action")
        end
      end

      ConcreteConcern.new(init_options)
    end

    it 'combines options' do
      allow(mapper).to receive(:resource_scope?).and_return(true)

      allow(mapper).to receive(:resource)
      expect(mapper).to receive(:resource).with(hash_including(as: :foo, to: 'foo#action'))

      a_two_level_concern.call(mapper, controller: :foo)
    end
  end

  it 'removes :on if the route is not a resoucrce scope'

end