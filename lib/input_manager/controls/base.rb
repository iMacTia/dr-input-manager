# frozen_string_literal: true

module InputManager
  module Controls
    # Abstract base class for all controls
    class Base
      # attribute [String] name of the control. This is used to access it, not for display.
      attr_reader :name
      # attribute [Devices::Base] the device to which this control belongs to.
      attr_reader :device
      # attribute [Proc] proc to apply to value.
      attr_reader :processor

      # attribute [Object] default value for the control. Used to determine if the control is actuated.
      attr_writer :default_value

      def initialize(name, device, &block)
        @name = name
        @device = device
        @processor = block || default_processor
        @previous_value = nil
        setup
      end

      def setup; end

      def default_value
        @default_value ||= self.class.default_value
      end

      def default_processor
        proc { |val| val }
      end

      def update
        @previous_value = @current_value
        @current_value = processor.call(raw_value)
      end

      def raw_value
        device.get_raw_value(name)
      end

      def pressed_this_frame?
        pressed? && changed?
      end

      def changed?
        @current_value != @previous_value
      end

      def value
        @current_value
      end

      def pressed?
        @current_value != default_value
      end

      def display_name
        "#{device.name}.#{name}"
      end
    end
  end
end
