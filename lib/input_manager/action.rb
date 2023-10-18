# frozen_string_literal: true

module InputManager
  class Action
    attr_reader :name, :bindings

    def initialize(name, bindings = [])
      @name = name
      @bindings = bindings
    end

    def add_binding(binding)
      @bindings << binding
    end
  end
end
