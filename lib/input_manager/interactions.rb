# frozen_string_literal: true

require_relative 'interactions/base'
require_relative 'interactions/hold'
require_relative 'interactions/press'
require_relative 'interactions/slow_tap'
require_relative 'interactions/tap'

module InputManager
  module Interactions
    def self.default_interaction
      Press.new
    end

    # Parses a string like "type" or "type1(param1=value1,param2=value2)" into an interaction instance
    def self.parse(definition)
      return definition if definition.is_a?(Base)

      type, params = parse_parts(definition)
      klass = Object.const_get("InputManager::Interactions::#{to_klass(type)}")
      kwargs = parse_params(params)

      klass.new(**kwargs)
    end

    # Returns a [type, params] tuple from an interaction definition string
    def self.parse_parts(definition)
      type, params = definition.split('(')
      params = params[0..-2] if params
      [type, params]
    end

    # Returns a hash of parsed params from a params string
    def self.parse_params(params)
      return {} unless params

      params
        .split(',')
        .map { |pair| pair.split('=') }
        .transform_keys(&:to_sym)
    end

    # Takes a snake_case string and turns it into a PascalCase class name.
    def self.to_klass(name)
      name.split('_').map(&:capitalize).join
    end
  end
end
