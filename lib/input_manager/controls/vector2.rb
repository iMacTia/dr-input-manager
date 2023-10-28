# frozen_string_literal: true

module InputManager
  module Controls
    class Vector2 < Base
      def setup
        @default_value = [0, 0]
      end

      def default_processor
        proc { |val| val.is_a?(Hash) ? rect_to_vector2(val) : (val || [0, 0]) }
      end

      private

      def rect_to_vector2(position_rect)
        [position_rect.x, position_rect.y]
      end
    end
  end
end
