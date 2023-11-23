# frozen_string_literal: true

module InputManager
  class Action
    TYPES = %i[value button].freeze

    attr_reader :name, :type, :control_type, :bindings, :interactions, :callbacks
    # attribute [Symbol] either :started, :performed or :cancelled
    attr_reader :phase
    attr_accessor :action_map, :active_control, :active_binding, :active_interaction, :enabled

    def initialize(name, type: :button, control_type: nil,
                   action_map: nil, orphan: false,
                   bindings: [], interactions: [])
      @name = name
      @type = type
      @control_type = control_type
      @callbacks = Hash.new { |h, k| h[k] = [] }
      @bindings = []
      @interactions = []
      @default_interaction = InputManager::Interactions.default_interaction.tap { |i| i.action = self }
      bindings.each { |b| add_binding(b) }
      interactions.each { |i| add_interaction(i) }

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

    def add_interaction(interaction)
      interaction.action = self
      @interactions << interaction
    end

    # This method is called after bindings have been resolved to update the action.
    def update
      return unless @active_control

      @all_interactions = find_all_interactions
      @all_interactions.each { |i| i.update(@active_control) }
      @active_interaction = find_active_interaction

      return unless @active_interaction

      @phase = @active_interaction.phase
      @performed_this_frame = active_interaction&.performed_this_frame?
      process_events
    end

    def find_all_interactions
      all_interactions = @active_binding.interactions + interactions
      all_interactions << @default_interaction if all_interactions.empty?
      all_interactions
    end

    def find_active_interaction
      active_interaction = @all_interactions.find { |i| i.started? || i.performed? }
      active_interaction ||= @all_interactions.find(&:cancelled?)
      active_interaction
    end

    def process_events
      @all_interactions.each do |interaction|
        interaction.fired_events.each do |event|
          callbacks[event].each { |callback| callback.call(interaction, @active_control) }
          action_map.trigger_event(event, self)
        end
      end
    end

    def value
      @active_control&.value || controls.first&.default_value || 0
    end

    def started?
      @active_interaction&.started? || false
    end

    def performed?
      @active_interaction&.performed? || false
    end

    def performed_this_frame?
      @active_interaction&.performed_this_frame? || false
    end

    def triggered?
      performed_this_frame?
    end

    def cancelled?
      @active_interaction&.cancelled? || false
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

    def reset_interactions
      @interactions = []
    end

    def started
      callbacks[:started]
    end

    def performed
      callbacks[:performed]
    end

    def cancelled
      callbacks[:cancelled]
    end

    def clone(new_action_map)
      cloned = super()
      cloned.action_map = new_action_map
      cloned.reset_bindings
      cloned.reset_interactions
      bindings.each { |b| cloned.add_binding(b) }
      interactions.each { |i| cloned.add_interaction(i) }
      cloned
    end
  end
end
