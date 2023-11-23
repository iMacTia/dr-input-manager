# frozen_string_literal: true

require 'lib/input_manager'
require_relative 'scenes/charged_attack_scene'
require_relative 'scenes/interactions_scene'

def tick(args)
  args.state.scene ||= InteractionsScene.new

  InputManager.update
  args.state.scene.tick
end
