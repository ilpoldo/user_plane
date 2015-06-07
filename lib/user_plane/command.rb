require 'imperator'

module UserPlane
  class Command < Imperator::Command
    include ActiveModel::Conversion

    def perform_validations(options={}) # :nodoc:
      options[:validate] == false || valid?
    end

    def perform(options={})
      if perform_validations(options)
        super()
        true
      else
        false
      end
    end

    def perform!(options={})
      raise Imperator::InvalidCommandError.new("Command was invalid") unless perform(options)
    end
  end  
end