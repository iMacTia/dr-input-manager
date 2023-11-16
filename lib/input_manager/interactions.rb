# frozen_string_literal: true

require_relative 'interactions/base'
require_relative 'interactions/tap'

module InputManager
  module Interactions
    def self.default_interaction
      Tap.new(duration: 0.2)
    end
  end
end
