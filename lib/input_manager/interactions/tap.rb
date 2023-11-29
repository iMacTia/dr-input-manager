# frozen_string_literal: true

module InputManager
  module Interactions
    class Tap < Base
      attr_reader :duration

      def initialize(action: nil, binding: nil, duration: nil)
        super(action: action, binding: binding)
        @duration = duration&.to_f || 0.2
      end

      def tap?
        true
      end

      def process
        return unless started?

        if pressed?
          cancel if press_time > duration
        elsif press_time <= duration
          perform
        end
      end
    end
  end
end
