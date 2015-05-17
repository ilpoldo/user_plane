require 'imperator'

module UserPlane
  class Command < Imperator::Command
    include ActiveModel::Conversion
  end  
end