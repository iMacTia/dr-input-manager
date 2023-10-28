# frozen_string_literal: true

module InputManager
  module Controls
    class Button < Base
      def setup
        @default_value = false
      end

      def default_processor
        proc { |val| !!val }
      end
    end
  end
end
