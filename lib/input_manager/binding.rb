# frozen_string_literal: true

module InputManager
  class Binding
    # attribute [Symbol] the type of device to which this binding applies.
    attr_reader :device_type
    # attribute [Symbol] the key (button/control) to listen to.
    attr_reader :key
    # attribute [Action] the action to which this binding is registered.
    attr_accessor :action
    # attribute [Array<Interaction>] list of interactions to put on the binding.
    attr_reader :interactions

    def initialize(device_type, key, action: nil, interactions: [])
      @device_type = device_type
      @key = key
      @action = action
      @interactions = interactions
    end

    def resolvable?
      !action.nil?
    end

    def resolve
      return unless resolvable?

      matching = action.controls.select { |control| valid_for?(control) }
      if matching.size < 2
        matching.first
      else
        matching.max_by(&:value)
      end
    end

    def valid_for?(control)
      !action.action_map.consumed?(control) && control.pressed? && matches?(control)
    end

    def matches?(control)
      control.device.type == device_type && key == control.name
    end

    def path
      @path ||= "#{device_type}/#{key}"
    end

    def complexity
      1
    end

    def to_s
      path
    end
  end
end
