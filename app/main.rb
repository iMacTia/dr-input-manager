# frozen_string_literal: true

require 'lib/input_manager.rb'

class Player
  attr_gtk

  attr_reader :jump_action

  def initialize
    @jump_action = InputManager::Action.new(:jump, bindings: [InputManager::Bindings::Simple.new(:keyboard, :space)])
  end

  def tick
    color = case @jump_action.phase
            when :started then { r: 0, g: 0, b: 255 }
            when :performed then { r: 0, g: 255, b: 0 }
            when :cancelled then { r: 255, g: 0, b: 0 }
            else { r: 155, g: 155, b: 155 }
            end
    $gtk.args.outputs.solids << { x: 100, y: 200, w: 50, h: 50 }.merge(color)
  end
end

def tick(args)
  args.state.player ||= Player.new

  InputManager.update # this is the magic bit that checks for inputs and updates controls
  args.state.player.tick
end
