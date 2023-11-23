# frozen_string_literal: true

module InputManager
  module Interactions
    class Hold < Base
      attr_reader :duration

      def initialize(action: nil, binding: nil, duration: nil)
        super(action: action, binding: binding)
        @duration = duration || 1.0
      end

      def hold?
        true
      end

      def process
        if pressed?
          perform if started? && press_time >= duration
        else
          cancel
        end
      end
    end
  end
end
