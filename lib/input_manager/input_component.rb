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
        if binding.is_a?(Array)
          next unless binding.all? { |b| b.active_on?(control_scheme) }
        else
          next unless binding.active_on?(control_scheme)
        end

        event_name = "on_#{action.name}".to_sym
        send(event_name) if respond_to?(event_name)
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
