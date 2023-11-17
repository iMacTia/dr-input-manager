# frozen_string_literal: true

module InputManager
  module Interactions
    class Press < Base
      BEHAVIOURS = %i[press_only release_only press_and_release].freeze

      attr_reader :behaviour

      def initialize(action: nil, binding: nil, behaviour: nil)
        super(action: action, binding: binding)
        @behaviour = behaviour || :press_only
      end

      def process
        if pressed?
          perform if started? && on_press?
        else
          perform if on_release? && (started? || performed?)
          cancel
        end
      end

      def perform
        super
        puts 'performed'
      end

      def on_press?
        behaviour == :press_only || behaviour == :press_and_release
      end

      def on_release?
        behaviour == :release_only || behaviour == :press_and_release
      end
    end
  end
end
