# frozen_string_literal: true

module InputManager
  module Interactions
    # Abstract base class for all interactions
    class Base
      attr_reader :state, :phase, :previous_phase, :current_control, :binding,
                  :pressed_at, :started_at, :performed_at, :cancelled_at
      attr_writer :action

      def initialize(action: nil, binding: nil)
        @action = action
        @binding = binding
        reset
      end

      def reset
        @state = :idle
        @phase = nil
        @current_control = nil
        @started_at = nil
        @performed_at = nil
        @cancelled_at = nil
        # @events_queue = []
      end

      def action
        @action || @binding&.action
      end

      def update(control)
        # @events_queue = []
        @previous_phase = @phase

        if processing?
          return unless control == current_control
        elsif control.pressed?
          start_processing(control)
        end

        process
        update_state
      end

      def idle?
        state == :idle
      end

      def start_processing(control)
        @current_control = control
        @state = :processing
        @pressed_at = Time.now
      end

      def processing?
        state == :processing
      end

      def pressed?
        processing? && current_control.pressed?
      end

      def press_time
        return 0.0 unless pressed_at

        Time.now - pressed_at
      end

      def started?
        phase == :started
      end

      def start
        @phase = :started
        @started_at = Time.now
        # @events_queue << :started
      end

      def performed?
        phase == :performed
      end

      def performed_this_frame?
        phase == :performed && previous_phase != :performed
      end

      def perform
        @phase = :performed
        @performed_at = Time.now
        # @events_queue << :performed
      end

      def cancelled?
        phase == :cancelled
      end

      def cancel
        @phase = :cancelled
        @cancelled_at = Time.now
        # @events_queue << :cancelled
      end

      def update_state
        @state = :idle if !current_control.pressed? && @phase == :cancelled || @phase == :performed
      end

      # TODO: fire events for event-driven API
      def fire_events
        @events_queue.each do |event|
          action.process_event(event, interaction)
        end
      end
    end
  end
end
