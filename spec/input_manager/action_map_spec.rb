# frozen_string_literal: true

spec InputManager::ActionMap do
  it 'initializes with a name' do
    action_map = InputManager::ActionMap.new(:name)
    expect(action_map.name).to eq(:name)
  end

  context '#devices' do
    it 'returns the default devices if not set' do
      action_map = InputManager::ActionMap.new(:name)
      expect(action_map.devices).to eq(InputManager.devices)
    end
  end

  context '#devices=' do
    it 'allows to set a custom list of devices' do
      devices = [InputManager.devices.sample]
      action_map = InputManager::ActionMap.new(:name)
      action_map.devices = devices
      expect(action_map.devices).to eq(devices)
    end
  end

  context '#register_action' do
    context 'when an action is passed' do
      before do
        @action = InputManager::Action.new(:test, orphan: true)
        @action_map = InputManager::ActionMap.new(:name)
        expect(@action_map.actions.size).to eq(0)
        @action_map.register_action(@action)
      end

      after do
        InputManager.reset_action_maps_registry
      end

      it 'register the action in the actions_registry' do
        expect(@action_map.actions_registry[:test]).to eq(@action)
      end

      it 'sets itself as the action action_map' do
        expect(@action_map.actions_registry[:test].action_map).to eq(@action_map)
      end

      it 'resets @actions to ensure the new action is loaded' do
        expect(@action_map.actions.size).to eq(1)
      end
    end

    context 'when a string is passed' do
      before do
        @action_name = 'test'
        @action_map = InputManager::ActionMap.new(:name)
        expect(@action_map.actions.size).to eq(0)
        @action_map.register_action(@action_name)
      end

      it 'creates and register an action in the actions_registry' do
        expect(@action_map.actions_registry['test']).to be_a(InputManager::Action)
      end

      it 'sets itself as the action action_map' do
        expect(@action_map.actions_registry['test'].action_map).to eq(@action_map)
      end

      it 'resets @actions to ensure the new action is loaded' do
        expect(@action_map.actions.size).to eq(1)
      end
    end

    context 'when a symbol is passed' do
      before do
        @action_name = :test
        @action_map = InputManager::ActionMap.new(:name)
        expect(@action_map.actions.size).to eq(0)
        @action_map.register_action(@action_name)
      end

      it 'creates and register an action in the actions_registry' do
        expect(@action_map.actions_registry[:test]).to be_a(InputManager::Action)
      end

      it 'sets itself as the action action_map' do
        expect(@action_map.actions_registry[:test].action_map).to eq(@action_map)
      end

      it 'resets @actions to ensure the new action is loaded' do
        expect(@action_map.actions.size).to eq(1)
      end
    end
  end
end
