# frozen_string_literal: true

module InputManager
  module InputComponent
    attr_accessor :control_scheme, :action_map

    def process_input
      return unless action_map

      action_map.actions.values.each do |action|
        process_action(action)
      end
    end

    private

    def process_action(action)
      action.bindings.each do |binding|
        bindings = corce_binding(binding)

        values = bindings.map { |b| b.value_on(control_scheme) }
        next unless values.all?

        call_listener(action, values.last)
      end
    end

    def corce_binding(binding)
      return binding if binding.is_a?(Array)

      [binding]
    end

    def call_listener(action, value)
      event_name = "on_#{action.name}".to_sym
      return unless respond_to?(event_name)

      if method(event_name).arity == 1
        send(event_name, value)
      else
        send(event_name)
      end
    end

    # def active?(binding)
    #   devices = control_scheme.devices_for(binding.input_device)

    #   devices.each do |device|
    #     binding.active_on?(device)
    #   end

    #   false
    # end
  end
end
