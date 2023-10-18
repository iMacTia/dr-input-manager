# frozen_string_literal: true

module InputManager
  class ActionMap
    attr_reader :name, :actions

    def initialize(name)
      @name = name
      @actions = {}
    end

    # @param action [String, Action] the action to register or its name
    # @param bindings [Array<Binding>] the bindings for this action. Optional, defaults to [].
    def register_action(action, bindings = [])
      action = Action.new(action.to_s, bindings) if action.is_a?(String) || action.is_a?(Symbol)
      actions[action.name] = action
    end
  end
end
