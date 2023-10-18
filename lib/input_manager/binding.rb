# frozen_string_literal: true

module InputManager
  class Binding
    attr_reader :input_device, :type, :key, :modifier

    def initialize(input_device, key, modifier = nil)
      @input_device = input_device
      @key = key
      @modifier = modifier
      @type = DEVICE_BINDINGS[input_device]
    end

    def path
      @path ||= "#{input_device}/#{key}"
    end

    def to_s
      @to_s ||= begin
        str = "#{key}"
        str += " (#{modifier})" if modifier
        str + " [#{input_device}]"
      end
    end

    def active_on?(control_scheme)
      devices = control_scheme.devices_for(input_device)

      return false unless devices.any?

      devices.each do |device|
        input = $gtk.args.inputs.send(device)
        input = input.send(modifier) if modifier

        return true if input.send(key)
      end

      false
    end

    private

    def detect_type
      return :value if DEVICE_BINDINGS[input_device][:values].include?(key)

      :button
    end
  end
end
