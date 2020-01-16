# Stub out the/any internal logging and provide a means of resetting the defined# levels
class LoggerWrapper
  require 'logger'
  def self.internal
    l = Logger.new(STDOUT, level: Logger::UNKNOWN)
  end

  module Level
    def reset_levels
      if defined?(@@levels) && !@@levels.nil? && @@levels.length
        @@levels.each { |l| LoggerWrapper.send(:remove_const, "#{l}") }
      end

      @@levels = []
    end
  end

  extend Level
  reset_levels
end

$default_levels = %w(TRACE DEBUG INFO WARN ERROR FATAL ON OFF)

RSpec.context 'LoggerWrapper' do
  it 'compiles/requires OK' do
    expect { require 'logger_wrapper/level' }.not_to raise_error
  end

  [ :levels, :set_levels ].each do |m|
    it "responds to \##{m}" do
      expect(LoggerWrapper).to respond_to(m)
    end
  end

  it '#levels() generates correct default list' do
    expect(LoggerWrapper.levels).to match_array $default_levels
  end
end

RSpec.context LoggerWrapper do
  shared_examples 'level setting' do |name, list|
    $no_reset = false

    describe "using levels - #{name} (#{list})" do
    before :all do
      LoggerWrapper.reset_levels
    end

      it 'method doesn\'t throw' do
        expect { LoggerWrapper.set_levels *list }.not_to raise_error
      end

      describe 'Level checks' do
        list.each_with_index do |l, i|
          it "#{l} exists and has correct value" do
            expect { LoggerWrapper.const_get(l) }.not_to raise_error
            expect(LoggerWrapper.const_get(l)).to eq i
          end
        end
      end

      describe 'responds correctly to subsequent invocations' do
        it 'method throws when env var set' do
          expect {
            ENV['LOGW_LEVEL_ERROR'] = 'some string'
            LoggerWrapper.set_levels
          }.to raise_error LoggerWrapper::Level::LevelsAlreadySetError
        end

        it 'method warns when env var not set' do
          expect {
            ENV['LOGW_LEVEL_ERROR'] = nil
            LoggerWrapper.set_levels
          }.to output(/WARNING: /).to_stderr
        end
      end
    end
  end

  describe LoggerWrapper do
    include_examples 'level setting', 'default', $default_levels
    include_examples 'level setting', 'bespoke', %w(ONE TWO THREE)
  end
end

#### END OF FILE
