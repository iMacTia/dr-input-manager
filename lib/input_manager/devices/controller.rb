# frozen_string_literal: true

module InputManager
  module Devices
    class Controller < Base
      AXES = %i[
        left_right up_down
        left_analog_x_raw right_analog_x_raw left_analog_y_raw right_analog_y_raw
        left_analog_x_perc right_analog_x_perc left_analog_y_perc right_analog_y_perc
      ].freeze

      BUTTONS = %i[
        up down left right a b x y
        l1 r1 l2 r2 l3 r3 start select
        directional_up directional_down directional_left directional_right
      ].freeze

      def initialize(name)
        super
        AXES.each { |a| @controls_registry[a] = Controls::Axis.new(a, self) }
        BUTTONS.each { |b| @controls_registry[b] = Controls::Key.new(b, self) }
        @controls_registry.merge!(
          {
            left_analog_raw: Controls::CombinedAxes.new(%i[left_analog_x_raw left_analog_y_raw], self),
            right_analog_raw: Controls::CombinedAxes.new(%i[right_analog_x_raw right_analog_y_raw], self),
            left_analog_perc: Controls::CombinedAxes.new(%i[left_analog_x_perc left_analog_y_perc], self),
            right_analog_perc: Controls::CombinedAxes.new(%i[right_analog_x_perc right_analog_y_perc], self)
          }
        )
      end
    end
  end
end
