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
  end
end
