# frozen_string_literal: true

module InputManager
  module Devices
    class Keyboard < Base
      BUTTONS = %i[
        active up down left right
        alt meta control shift exclamation_point
        zero one two three four five six seven eight nine
        backspace delete escape enter tab shift control alt meta
        open_round_brace close_round_brace open_curly_brace close_curly_brace open_square_brace close_square_brace
        colon semicolon equal_sign hyphen space dollar_sign double_quotation_mark single_quotation_mark
        backtick tilde period comma pipe underscore
        a b c d e f g h i j k l m n o p q r s t u v w x y z
        pageup pagedown char plus at forward_slash back_slash asterisk less_than greater_than carat ampersand
        superscript_two circumflex question_mark section_sign
      ].freeze

      def initialize(name)
        super
        BUTTONS.each { |b| @controls_registry[b] = Controls::Key.new(b, self) }
        @controls_registry.merge!(
          {
            left_right: Controls::Axis.new(:left_right, self),
            up_down: Controls::Axis.new(:up_down, self),
            directional_vector: Controls::Vector2.new(:directional_vector, self)
          }
        )
      end
    end
  end
end
