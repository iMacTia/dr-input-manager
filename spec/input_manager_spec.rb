# frozen_string_literal: true

spec InputManager do
  context '.devices_registry' do
    it 'contains a hash of all the devices' do
      expect(InputManager.devices_registry).to be_a(Hash)
    end

    it 'automatically setup the standard DR devices' do
      devices = %i[mouse keyboard touch controller_one controller_two controller_three controller_four]
      expect(InputManager.devices_registry.keys).to eq(devices)
    end
  end

  context '.devices' do
    it 'returns a list of devices' do
      expect(InputManager.devices).to be_a(Array)
      expect(InputManager.devices.size).to eq(7)
      expect(InputManager.devices.first).to be_a(InputManager::Devices::Base)
    end
  end

  context '.devices_registry' do
    it 'contains a hash of all the action maps' do
      expect(InputManager.action_maps_registry).to be_a(Hash)
    end

    it 'automatically setup the default action map' do
      expect(InputManager.action_maps_registry.keys).to eq(%i[default])
    end
  end

  context '.register_action_map' do
    after do
      InputManager.reset_action_maps_registry
    end

    it 'registers the action map in the registry' do
      test_am = InputManager::ActionMap.new(:test)
      InputManager.register_action_map(test_am)

      expect(InputManager.action_maps_registry.size).to eq(2)
      expect(InputManager.action_maps_registry[:test]).to eq(test_am)
    end
  end

  context '.action_maps' do
    it 'returns a list of action_maps' do
      expect(InputManager.action_maps).to be_a(Array)
      expect(InputManager.action_maps.size).to eq(1)
      expect(InputManager.action_maps.first).to be_a(InputManager::ActionMap)
    end
  end

  context '.actions' do
    before do
      InputManager::Action.new(:test)
    end

    after do
      InputManager.default_action_map.reset
    end

    it 'returns a list of actions from action_maps' do
      expect(InputManager.actions).to be_a(Array)
      expect(InputManager.actions.size).to eq(1)
      expect(InputManager.actions.first).to be_a(InputManager::Action)
    end
  end

  context '.update' do
    before do
      InputManager::Action.new(:test, bindings: [InputManager::Bindings::Simple.new(:keyboard, :space)])
    end

    after do
      InputManager.default_action_map.reset
    end

    it 'updates all enabled devices and actions' do |_args, assert|
      InputManager.update
      assert.ok!
    end
  end
end
