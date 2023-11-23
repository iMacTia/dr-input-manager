# frozen_string_literal: true

module InputManager
  module Interactions
    class SlowTap < Base
      attr_reader :duration

      def initialize(action: nil, binding: nil, duration: nil)
        super(action: action, binding: binding)
        @duration = duration || 0.2
      end

      def slow_tap?
        true
      end

      def process
        return unless started? && released?

        press_time >= duration ? perform : cancel
      end
    end
  end
end
