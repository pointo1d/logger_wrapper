
RSpec.describe 'Core Object extension' do
  it 'compiles/requires OK' do
    expect {
      require 'extensions/core/object'
    }.not_to raise_error

  end

  require 'extensions/core/object'

  context 'responds to extensions' do
    it "responds to #unfreeze" do
      expect(Object.new).to respond_to(:unfreeze)
    end
  end
  
  describe 'unfreeze works as expected' do
    it 'unfreezes without error' do
      @frozen = 'Frozen string'.freeze
      expect { @frozen.unfreeze }.not_to raise_error
    end

    it 'unfreezes without mutating' do
      @unfrozen = 'Frozen string'.freeze
      @unfrozen.unfreeze
      expect(@unfrozen.frozen?).to be false
      expect(@unfrozen).to eq 'Frozen string'
    end

    it 'refreezes without error' do
      @refrozen = 'Frozen string'.freeze
      @refrozen.unfreeze
      expect(@refrozen.frozen?).to be false
      expect(@refrozen).to eq 'Frozen string'
      expect { @refrozen.freeze }.not_to raise_error
    end

    it 'updates unfrozen var without error' do
      @updfrozen = 'Frozen string'.freeze
      @updfrozen.unfreeze
      expect { @updfrozen = 'new string' }.not_to raise_error
      expect(@updfrozen).to eq 'new string'
    end
  end
end

#### END OF FILE
