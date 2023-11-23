# frozen_string_literal: true

module InputManager
  class Timeout
    attr_reader :started_at, :duration, :block

    def initialize(duration, &block)
      @started_at = Time.now
      @duration = duration
      @block = block
    end

    def key
      object_id.to_s
    end

    def update
      return if elapsed < duration

      cancel
      @block.call
    end

    def elapsed
      Time.now - started_at
    end

    def cancel
      InputManager.remove_timeout(self)
    end
  end
end
