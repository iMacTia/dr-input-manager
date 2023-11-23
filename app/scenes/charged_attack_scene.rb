# frozen_string_literal: true

class ChargedAttackScene
  def initialize
    threshold = 0.3

    @attack_action = InputManager::Action.new(
      :press,
      bindings: [
        InputManager::Bindings::Simple.new(:keyboard, :space)
      ],
      interactions: [
        InputManager::Interactions::Tap.new(duration: threshold),
        InputManager::Interactions::SlowTap.new(duration: threshold)
      ]
    )

    @attack_action.performed << method(:on_performed)
    @attack_action.cancelled << method(:on_cancelled)
  end

  def on_performed(interaction, _control)
    @feedback_label = interaction.tap? ? 'normal attack performed' : 'charged attack performed'
    InputManager.set_timeout(0.6) { @feedback_label = nil }
  end

  def on_cancelled(interaction, _control)
    @feedback_label = 'charging...' if interaction.tap?
  end

  def tick
    $gtk.args.outputs.labels << [640, 350, @feedback_label, 48, 1] if @feedback_label
    $gtk.args.outputs.labels << [640, 150, 'SPACE PRESSED', 24, 1] if $gtk.args.inputs.keyboard.key_held.space
  end
end
