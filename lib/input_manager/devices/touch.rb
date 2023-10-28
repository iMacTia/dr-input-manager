# frozen_string_literal: true

module InputManager
  module Devices
    class Touch < Base
      def initialize(name)
        super
        @controls_registry = {
          finger_one: Controls::Vector2.new(:finger_one, self),
          finger_two: Controls::Vector2.new(:finger_two, self)
        }
      end

      # Touch is a special case, as controls are accessed via the main `inputs` prop.
      def get_raw_value(control_name)
        $gtk.args.inputs.send(control_name)
      end

      # TODO: Add support for more than 2 fingers touch.
      #   See http://docs.dragonruby.org.s3-website-us-east-1.amazonaws.com/samples.html#----touch---main-rb
    end
  end
end
