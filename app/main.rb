# frozen_string_literal: true

require 'lib/input_manager.rb'

class Player
  attr_gtk

  PHASE_COLOR_MAP = {
    started: { r: 0, g: 0, b: 255 },
    performed: { r: 0, g: 255, b: 0 },
    cancelled: { r: 255, g: 0, b: 0 }
  }
  PHASE_COLOR_MAP.default = { r: 155, g: 155, b: 155 }

  attr_reader :jump_action

  def initialize
    @press_action = InputManager::Action.new(
      :press,
      bindings: [
        InputManager::Bindings::Simple.new(:keyboard, :space)
      ]
    )

    @hold_action = InputManager::Action.new(
      :hold,
      bindings: [
        InputManager::Bindings::Simple.new(:keyboard, :space)
      ],
      interactions: [InputManager::Interactions::Hold.new]
    )

    @tap_action = InputManager::Action.new(
      :tap,
      bindings: [
        InputManager::Bindings::Simple.new(:keyboard, :space)
      ],
      interactions: [InputManager::Interactions::Tap.new]
    )

    @slow_tap_action = InputManager::Action.new(
      :slow_tap,
      bindings: [
        InputManager::Bindings::Simple.new(:keyboard, :space)
      ],
      interactions: [InputManager::Interactions::SlowTap.new]
    )
  end

  def tick
    $gtk.args.outputs.labels << [450, 500, 'PRESS', 0, 0]
    $gtk.args.outputs.solids << { x: 450, y: 400, w: 50, h: 50 }.merge(PHASE_COLOR_MAP[@press_action.phase])
    $gtk.args.outputs.labels << [550, 500, 'HOLD', 0, 0]
    $gtk.args.outputs.solids << { x: 550, y: 400, w: 50, h: 50 }.merge(PHASE_COLOR_MAP[@hold_action.phase])
    $gtk.args.outputs.labels << [650, 500, 'TAP', 0, 0]
    $gtk.args.outputs.solids << { x: 650, y: 400, w: 50, h: 50 }.merge(PHASE_COLOR_MAP[@tap_action.phase])
    $gtk.args.outputs.labels << [750, 500, 'SLOW TAP', 0, 0]
    $gtk.args.outputs.solids << { x: 750, y: 400, w: 50, h: 50 }.merge(PHASE_COLOR_MAP[@slow_tap_action.phase])

    $gtk.args.outputs.labels << [640, 350, 'BUTTON PRESSED', 0, 1] if $gtk.args.inputs.keyboard.space
  end
end

def tick(args)
  args.state.player ||= Player.new

  InputManager.update # this is the magic bit that checks for inputs and updates controls
  args.state.player.tick
end
