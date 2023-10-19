# frozen_string_literal: true

require 'lib/input_manager.rb'

gameplay_am = InputManager::ActionMap.new('Gameplay')

# Then, we register a "jump" action mapped to the spacebar key_down event.
gameplay_am.register_action(:jump, [InputManager::Binding.new(:keyboard, :space, :key_down)])

# It can be useful to register this action map with the `InputManager`, so that it can be reused.
# It also makes it easy to reference it from other files.
# They can be retrieved using their `name`, so make sure that's unique.
InputManager.register_action_map(gameplay_am)

class Player
  include InputManager::InputComponent

  def initialize
    # In order for InputComponent to do its magic, you need to specify a control_scheme and input_map
    # for your entity instance. These are instance variables because you can re-map them on the go!
    @control_scheme = InputManager::ControlScheme.keyboard
    @action_map = InputManager.action_maps['Gameplay']
  end

  def tick(args)
    @args = args
    process_input # this is the magic bit that checks for inputs and calls listeners like `on_jump`

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
  player ||= Player.new
  args.state.counter ||= 0

  player.tick(args)
end
