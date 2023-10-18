# frozen_string_literal: true

# InputManager main module.
# Defines useful constants and helpers that can be used by its classes.
# The module is responsible for managing all input across devices and dispatching input events.
# This creates an abstraction layer that decouples input handling from game logic.
#
# It defines 4 core components:
# 1. Control Scheme - Represents one or more input devices bound together under a scheme (e.g. Keyboard, Gamepad).
# 2. Action - Represents an input event that can be triggered (e.g. Jump, Shoot).
# 3. Binding - Maps an input (e.g. Spacebar) to an Action.
# 4. ActionMap - Groups Actions and their Bindings together.
#
# Components/Entities (e.g. Sprites) consume inputs by including the InputComponent module and
# specifying the control scheme and action map to use.
module InputManager
  INPUT_DEVICES = %i[keyboard mouse touch controller_one controller_two controller_three controller_four].freeze

  CONTROLLER_BINDINGS = {
    buttons: %i[
      up down left right a b x y
      l1 r1 l2 r2 l3 r3 start select
      directional_up directional_down directional_left directional_right
    ],
    values: %i[
      left_right up_down
      left_analog_x_raw right_analog_x_raw left_analog_y_raw right_analog_y_raw
      left_analog_x_perc right_analog_x_perc left_analog_y_perc right_analog_y_perc
    ]
  }.freeze

  KEYBOARD_BINDINGS = {
    buttons: %i[
      active up down left right
      alt meta control shift exclamation_point
      zero one two three four five six seven eight nine
      backspace delete escape enter tab shift control alt meta
      open_round_brace close_round_brace open_curly_brace close_curly_brace open_square_brace close_square_brace
      colon semicolon equal_sign hyphen space dollar_sign double_quotation_mark single_quotation_mark
      backtick tilde period comma pipe underscore
      a b c d e f g h i j k l m n o p q r s t u v w x y z
      pageup pagedown char plus at forward_slash back_slash asterisk less_than greater_than carat ampersand
      superscript_two circumflex question_mark section_sign raw_key
      ctrl_up ctrl_down ctrl_left ctrl_right
      ctrl_zero ctrl_one ctrl_two ctrl_three ctrl_four ctrl_five ctrl_six ctrl_seven ctrl_eight ctrl_nine
      ctrl_backtick ctrl_tilde ctrl_period ctrl_comma ctrl_pipe ctrl_underscore
      ctrl_a ctrl_b ctrl_c ctrl_d ctrl_e ctrl_f ctrl_g ctrl_h ctrl_i ctrl_j ctrl_k ctrl_l ctrl_m
      ctrl_n ctrl_o ctrl_p ctrl_q ctrl_r ctrl_s ctrl_t ctrl_u ctrl_v ctrl_w ctrl_x ctrl_y ctrl_z
      ctrl_pageup ctrl_pagedown ctrl_char ctrl_plus ctrl_at ctrl_carat ctrl_ampersand ctrl_circumflex
    ],
    values: %i[
      left_right up_down directional_vector truthy_keys ordinal_indicator
    ]
  }.freeze

  MOUSE_BINDINGS = {
    buttons: %i[button_left button_middle button_right moved],
    values: %i[x y button_bits wheel click down previous_click up]
  }.freeze

  TOUCH_BINDINGS = {
    buttons: [],
    values: %i[touch finger_left finger_right]
  }.freeze

  DEVICE_BINDINGS = {
    controller: CONTROLLER_BINDINGS,
    keyboard: KEYBOARD_BINDINGS,
    mouse: MOUSE_BINDINGS,
    touch: TOUCH_BINDINGS
  }.freeze

  BINDING_MODIFIERS = %i[key_down key_held key_up].freeze

  class << self
    def action_maps
      @action_maps ||= {}
    end

    def register_action_map(name, action_map)
      action_maps[name] = action_map
    end

    # Predefined control schemes
    def keyboard
      @keyboard ||= ControlScheme.new([:keyboard])
    end

    def keyboard_and_mouse
      @keyboard_and_mouse ||= ControlScheme.new(%i[keyboard mouse])
    end
  end
end

require_relative 'input_manager/action_map'
require_relative 'input_manager/action'
require_relative 'input_manager/binding'
require_relative 'input_manager/control_scheme'
require_relative 'input_manager/input_component'
