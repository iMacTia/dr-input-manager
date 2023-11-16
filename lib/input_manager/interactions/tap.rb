# frozen_string_literal: true

module InputManager
  module Interactions
    class Tap < Base
      attr_reader :duration

      def initialize(action: nil, binding: nil, duration: nil)
        super(action: action, binding: binding)
        @duration = duration || 0.2
      end

      def process
        if pressed?
          cancel if press_time > duration
        elsif press_time <= duration
          perform
        end
      end

      def start_processing(_control)
        super
        start
      end
    end
  end
end
