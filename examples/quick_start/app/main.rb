# frozen_string_literal: true

require 'lib/input_manager.rb'

class Player
  def initialize
    @jump_action = InputManager::Action.new(:jump, bindings: [InputManager::Bindings::Simple.new(:keyboard, :space)])
  end

  def tick(args)
    @args = args
    on_jump if @jump_action.triggered?

    args.state.counter -= 1
    args.outputs.labels << [640, 360, 'JUMP!', 0] if args.state.counter >= 0
  end

  # This is a listener, they're conventionally called `on_<action_name>`
  def on_jump
    puts 'JUMP!'
    @args.state.counter = 60
  end
end

def tick(args)
  args.state.player ||= Player.new #add player to the state to have it save. not being part of state recreates the object every tick.
  args.state.counter ||= 0

  InputManager.update # this is the magic bit that checks for inputs and updates controls
  args.state.player.tick(args) #add the args.state. reference
end
