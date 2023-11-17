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
  end
end
