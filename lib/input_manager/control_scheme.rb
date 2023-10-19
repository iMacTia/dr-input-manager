# frozen_string_literal: true

module InputManager
  class ControlScheme
    attr_reader :input_devices

    DEVICE_MAPPING = {
      controller_one: :controller,
      controller_two: :controller,
      controller_three: :controller,
      controller_four: :controller,
      keyboard: :keyboard,
      mouse: :mouse,
      touch: :touch
    }.freeze

    def initialize(input_devices)
      @input_devices = input_devices
    end

    def devices_for(type)
      input_devices.select { |device| DEVICE_MAPPING[device] == type }
    end

    def device_types
      @device_types ||= input_devices.map { |device| DEVICE_MAPPING[device] }.uniq
    end

    def to_s
      input_devices.join(' + ')
    end

    # Predefined control schemes
    class << self
      def keyboard
        @keyboard ||= new([:keyboard])
      end

      def mouse
        @mouse ||= new([:mouse])
      end

      def keyboard_and_mouse
        @keyboard_and_mouse ||= new(%i[keyboard mouse])
      end

      def touch
        @touch ||= new([:touch])
      end

      def controller(slot)
        @controllers ||= {
          one: new([:controller_one]),
          two: new([:controller_two]),
          three: new([:controller_three]),
          four: new([:controller_four])
        }
        @controllers[slot] || raise('Invalid slot. Should be :one, :two, :three, or :four')
      end
    end
  end
end
