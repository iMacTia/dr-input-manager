# frozen_string_literal: true

# InputManager main module.
# Defines useful constants and helpers that can be used by its classes.
# The module is responsible for managing all input across devices and dispatching input events.
# This creates an abstraction layer that decouples input handling from game logic.
#
# It defines 4 core components:
# 1. Control Scheme - Represents one or more input devices bound together under a scheme (e.g. Keyboard, Gamepad).
# 2. Action - Represents an input event that can be triggered (e.g. Jump, Shoot).
# 3. Binding - Maps an input (e.g. Spacebar) to an Action.
# 4. ActionMap - Groups Actions and their Bindings together.
#
# Components/Entities (e.g. Sprites) consume inputs by including the InputComponent module and
# specifying the control scheme and action map to use.
module InputManager
  class << self
    def devices_registry
      @devices_registry ||= {
        mouse: Devices::Mouse.new(:mouse),
        keyboard: Devices::Keyboard.new(:keyboard),
        touch: Devices::Touch.new(:touch),
        controller_one: Devices::Controller.new(:controller_one),
        controller_two: Devices::Controller.new(:controller_two),
        controller_three: Devices::Controller.new(:controller_three),
        controller_four: Devices::Controller.new(:controller_four)
      }
    end

    def timeouts
      @timeouts ||= {}
    end

    def devices
      @devices ||= devices_registry.values
    end

    def set_timeout(duration, &block)
      timeout = Timeout.new(duration, &block)
      timeouts[timeout.key] = timeout
    end

    def remove_timeout(timeout)
      timeouts.delete(timeout.key)
    end

    def action_maps_registry
      @action_maps_registry ||= default_action_maps_registry
    end

    def register_action_map(action_map)
      action_maps_registry[action_map.name] = action_map
      @action_maps = nil
    end

    def action_maps
      @action_maps ||= action_maps_registry.values
    end

    def actions
      action_maps.flat_map(&:actions)
    end

    # Main method responsible for updating all controls and actions.
    def update
      timeouts.each_value(&:update)
      devices.select(&:enabled?).each(&:update)
      action_maps.select(&:enabled?).each(&:update)
    end

    def reset_action_maps_registry
      @default_action_map = nil
      @action_maps_registry = nil
    end

    def default_action_maps_registry
      { default: default_action_map }
    end

    def default_action_map
      @default_action_map ||= ActionMap.new(:default)
    end
  end
end

require_relative 'input_manager/timeout'
require_relative 'input_manager/action_map'
require_relative 'input_manager/action'
require_relative 'input_manager/bindings'
require_relative 'input_manager/control_scheme'
require_relative 'input_manager/input_component'
require_relative 'input_manager/devices'
require_relative 'input_manager/controls'
require_relative 'input_manager/interactions'
