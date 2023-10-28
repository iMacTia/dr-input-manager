# frozen_string_literal: true

module InputManager
  module Controls
    class CombinedAxes < Vector2
      def raw_value
        name.map { |axis_name| device.get_raw_value(axis_name) }
      end
    end
  end
end
