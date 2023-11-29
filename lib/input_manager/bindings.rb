# frozen_string_literal: true

require_relative 'bindings/base'
require_relative 'bindings/simple'

module InputManager
  module Bindings
    # Parses a string like "device_type/key"
    def self.parse(definition)
      return definition if definition.is_a?(Base)

      device_type, key = definition.split('/').map(&:to_sym)
      Simple.new(device_type, key)
    end
  end
end
