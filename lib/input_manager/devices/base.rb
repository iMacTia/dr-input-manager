# frozen_string_literal: true

module InputManager
  module Devices
    class Base
      # attribute [Symbol] the device name.
      attr_reader :name
      # attribute [Hash<Controls::Base>] list of controls for the device.
      attr_reader :controls_registry

      class << self
        def type
          @type ||= name.split('::').last.downcase.to_sym
        end
      end

      def initialize(name)
        @name = name
        @controls_registry = {}
      end

      def type
        self.class.type
      end

      def get_raw_value(control_name)
        $gtk.args.inputs.send(name).send(control_name)
      end

      def update
        controls.each(&:update)
      end

      def controls
        @controls ||= controls_registry.values
      end

      def control(name)
        controls_registry[name]
      end

      def method_missing(name)
        control(name)
      end

      def respond_to_missing?(name)
        controls_registry.key?(name.to_s) || super
      end
    end
  end
end
