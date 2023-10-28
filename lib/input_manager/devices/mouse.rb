# frozen_string_literal: true

module InputManager
  module Devices
    class Mouse < Base
      def initialize(name)
        super
        @controls_registry = {
          x: Controls::Button.new(:x, self),
          y: Controls::Button.new(:y, self),
          button_left: Controls::Button.new(:button_left, self),
          button_middle: Controls::Button.new(:button_middle, self),
          button_right: Controls::Button.new(:button_right, self),
          button_bits: Controls::Button.new(:button_bits, self),
          position: Controls::Vector2.new(:position, self),
          click: Controls::Vector2.new(:click, self),
          previous_click: Controls::Vector2.new(:previous_click, self),
          wheel: Controls::Vector2.new(:wheel, self),
          up: Controls::Vector2.new(:up, self),
          down: Controls::Vector2.new(:down, self)
        }
      end
    end
  end
end
