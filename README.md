# dr-input-manager

Input Manager for DragonRuby GTK Projects

## Install

### Using smaug

Add the following to your smaug dependencies and run `smaug install`:

```toml
dr-input-manager = { repo = "https://github.com/iMacTia/dr-input-manager" }
```

### Manually

Copy the content of the `lib` folder in your project and require `input_manager.rb`

## Quick Usage

Let's just take a look at how you can use the `InputManager` to listen for input events.
The idea is that you can create action maps and bindings, and then use these in your entities
via the `InputComponent` helper.

`InputManager` allows you to define several action maps and control schemes, but let's keep things
simple for now and assume there's only one action map that uses the `keyboard` control scheme.

First, we define the action map with one action called "jump".
The action will be triggered by pressing the space bar on the keyboard (binding):

```ruby
# We define a "Gameplay" action map, you can name it whatever you want.
gameplay_am = InputManager::ActionMap.new('Gameplay')

# Then, we register a "jump" action mapped to the spacebar key_down event.
gameplay_am.register_action(:jump, [InputManager::Binding.new(:keyboard, :space, :key_down)])

# It can be useful to register this action map with the `InputManager`, so that it can be reused.
# It also makes it easy to reference it from other files.
# They can be retrieved using their `name`, so make sure that's unique.
InputManager.register_action_map(gameplay_am)
```

Now that your action map is defined, you can add an `InputComponent` to entities that should respond to input events.
All you need to do is to:
* Include the `InputManager::InputComponent` module
* Specify the `@control_scheme` and `@action_map` instance variables
* Define `on_<action_name>` listener methods (these will be called automatically when the corresponding action is triggered)
* Make sure your object calls `process_input` on each tick

```ruby
class Player
  include InputManager::InputComponent

  def initialize
    # In order for InputComponent to do its magic, you need to specify a control_scheme and input_map
    # for your entity instance. These are instance variables because you can re-map them on the go!
    @control_scheme = InputManager::ControlScheme.keyboard
    @action_map = InputManager.action_maps['Gameplay']
  end

  def tick
    process_input # this is the magic bit that checks for inputs and calls listeners like `on_jump`
  end

  # This is a listener, they're conventionally called `on_<action_name>`
  def on_jump
    puts 'JUMP!'
  end
end
```

And that's it! Now if you run this on your main file, you will see "JUMP!" printed whenever you press the spacebar key.

```ruby
def tick args
  player ||= Player.new
  player.tick
end
```

You can find this quick start example under `examples/quick_start`,
and you can run it from the root of this project with `smaug run -p examples/quick_start`.
(NOTE: You'll first need to copy the `lib` folder from the project root into the examples/quick_start folder).

If you don't use `smaug` you can copy the example folder next to your `dragonruby` executable and run it with that.

## Core components

Now that we've seen it in action, let's dive deeper into how the Input Manager works under the hood.
The Input Manager introduces 4 core components:
1. Control Scheme - Represents one or more input devices bound together under a scheme (e.g. Keyboard, Gamepad).
2. Action - Represents an input event that can be triggered (e.g. Jump, Shoot).
3. Binding - Represents a button/key/input and it's state.
4. ActionMap - Groups Actions and their Bindings together.

Let's take a closer look at each of them.

### Control Scheme

This represents an input device or combination of devices that can be used for input.

If you're wondering why you'd ever need to use a combination of devices, think about the classic "keyboard and mouse"
control scheme that we're used to for FPS games, where the keyboard is used for movement and actions,
while the mouse controls camera look. Another example could be combining a gamepad with motion controls
from something like VR controllers.

You can define your own Control Scheme with any combination of input devices you can think of:

```ruby
# Available inputs: :keyboard, :mouse, :touch, :controller_(one|four)
cs = InputManager::ControlScheme.new([:touch, :mouse])
```

Or use one of the pre-defined schemes InputManager comes with:
* `InputManager::ControlScheme.keyboard` - Represents keyboard input
* `InputManager::ControlScheme.mouse` - Represents mouse input
* `InputManager::ControlScheme.keyboard_and_mouse` - Represents a combination of keyboard and mouse input
* `InputManager::ControlScheme.controller(:one/:four)` - Represents the 4 controllers managed by DR
* `InputManager::ControlScheme.touch` - Represents touch input for mobile devices

### Binding

A binding represents a specific button, key or input state that can trigger an action.
Examples of this are "space on the keyboard pressed", or "mouse button clicked".
They depend on what DragonRuby's `args.inputs` provides.

You can create a binding by specifying the input device and button/key, plus optionally
providing a state/modifier as well.

```ruby
# Example without a modifier.
# Returns true if up is pressed or held on the directional
binding = Binding.new(
  :keyboard, # input device
  :directional_up # key/button
)

# Example with modifier.
# Returns true if the A button on a controller was pressed on this frame.
binding = Binding.new(
  :controller, # input device. Note how we don't need to specify the controller number, that's a concern for the scheme.
  :a, # key/button
  :key_down # modifier
)
```

#### State vs Value bindings

Not all inputs are simply on/off states. Some provide a continuous value, like the position of a joystick,
the coordinates of the mouse pointer, or touch inputs.

`InputManager` knows which bindings are value-based versus state-based, and handles them appropriately.
Value bindings return the current value of the input on each frame rather than a true/false state.
This allows actions to use values for things like camera look based on mouse movement or touch drag gestures.

You can access the value by defining a listener that takes the value as an argument:

```ruby
def on_jump(value)
  # here value will be what DragonRuby returns when calling `args.inputs.<binding>`
end
```

### Action

Actions are logical events that represent something the player can trigger through input,
like jumping, shooting, attacking, dodging, etc.
Each action has a name and one or more `Binding`s associated with it to define how it can be triggered through input.

```ruby
jump = InputManager::Action.new(
  :select, # the name of the action
  [Binding.new(:keyboard, :enter, :key_down)] # the list of bindings that trigger the action
)
```

Note that bindings can be associated with *multiple input devices*, allowing for alternate trigger methods.
The action will trigger when *ANY* of its specified bindings are activated on the current frame.
This allows for flexible input mapping - for example a "jump" action could be triggered by pressing
either the spacebar on the keyboard or the A button on a controller.

```ruby
jump = InputManager::Action.new(
  :jump, # the name of the action
  [
    Binding.new(:keyboard, :space, :key_down),
    Binding.new(:controller, :a, :key_down)
  ]
)
```

#### Composite bindings

An action can have composite bindings that check multiple bindings at once.
This allows checking combinations of inputs like "shift + w" or "left trigger held + a button pressed".
To define a composite binding you can pass an array of bindings to the action:

```ruby
# DragonRuby doesn't have an event for left_click, only a "left_button" and a generic "click" events.
# Using only the former will cause the action to trigger on each frame where the left button is held down, 
# while the latter will correctly trigger only once, but does not distinguish between different mouse buttons.
#
# You can create a composite binding that checks both:
left_click = InputManager::Action.new(
  :left_click, # the name of the action
  [
    Binding.new(:mouse, :click),
    Binding.new(:mouse, :button_left)
  ]
)
```

### ActionMap

ActionMaps group Actions together to create logical sets of input bindings for different contexts.
A common use case is having different ActionMaps for different game modes or phases, like a "Gameplay"
map with actions for movement, attacking etc and a "Menu" map with actions for navigating menus.

However, more complex games might benefit to have more specific ActionMaps for different contexts,
like a game where the player can pilot vehicles or enter combats. In those cases you may want
separate ActionMaps for "Explore", "Vehicle", "Combat" modes so bindings don't conflict between contexts.

```ruby
gameplay_am = InputManager::ActionMap.new('Gameplay').tap |am|
  am.register_action(:jump, [InputManager::Binding.new(:keyboard, :space, :key_down)])
  am.register_action(:fire, [InputManager::Binding.new(:mouse, :click)])
end

# As we saw in the "Quick Start" above, this is ptional but useful.
InputManager.register_action_map(gameplay_am)
```