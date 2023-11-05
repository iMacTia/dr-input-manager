# frozen_string_literal: true

module InputManager
  class Action
    TYPES = %i[value button].freeze

    attr_reader :name, :type, :control_type, :bindings
    # attribute [Symbol] either :started, :performed or :cancelled
    attr_reader :phase
    attr_accessor :action_map, :active_control, :enabled

    def initialize(name, type: :button, control_type: nil, bindings: [], action_map: nil, orphan: false)
      @name = name
      @type = type
      @control_type = control_type
      @bindings = []
      bindings.each { |b| add_binding(b) }

      unless orphan || action_map
        action_map = InputManager.default_action_map
        action_map.register_action(self)
      end

      @action_map ||= action_map
      @performed_this_frame = false
    end

    def enabled?
      @enabled.nil? ? action_map.enabled? : !!@enabled
    end

    def devices
      @devices || action_map.devices
    end

    def devices=(list)
      @devices = list
      reset_controls
    end

    def add_binding(binding)
      binding.action = self
      @bindings << binding
    end

    # This method is called after bindings have been resolved to update the action.
    def update
      return unless @active_control

      @performed_this_frame = @active_control.pressed_this_frame?
    end

    def value
      @active_control&.value
    end

    def controls
      @controls ||= devices.flat_map(&:controls).compact
    end

    def reset_controls
      @controls = nil
    end

    def reset_bindings
      @bindings = []
    end

    def triggered?
      @performed_this_frame
    end

    def clone(new_action_map)
      cloned = super()
      cloned.action_map = new_action_map
      cloned.reset_bindings
      bindings.each { |b| cloned.add_binding(b) }
      cloned
    end
  end
end
