require 'imperator'

module UserPlane
  class Command < Imperator::Command
    def to_model
      self
    end
  end  
end