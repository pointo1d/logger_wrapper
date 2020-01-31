require 'rspec'

describe 'basics - require, include & extend' do
  it 'requires ok' do
    expect { require 'lumberjack/easy' }.not_to raise_error
  end

  it 'extends ok' do
    expect {
      class ExtendIt
        require 'lumberjack/easy'
        extend Lumberjack::Easy
      end
    }.not_to raise_error
  end

  it 'includes ok' do
    expect {
      class ExtendIt
        require 'lumberjack/easy'
        include Lumberjack::Easy
      end
    }.not_to raise_error
  end

  it 'extends & includes ok' do
    expect {
      class ExtendIt
        require 'lumberjack/easy'
        extend Lumberjack::Easy
        include Lumberjack::Easy
      end
    }.not_to raise_error
  end
end

METHODS = {
  'core'  => {
    'gen'  => %w(#debug #info #warn #error #fatal #unknown),
    'non_gen' => %w(
      ::new #<< #close #datetime_format #datetime_format= #level= #reopen
      #sev_threshold= #debug? #info? #warn? #error? #fatal?  #unknown?
    )
  },
  'extra' => {
    'gen'     => %w(#trace #entry #exit),
    'non_gen' => %w(
      #callret? #on #on? #off #off? #levels #trace? #entry? #exit?
    ),
  }
}

require 'lumberjack/easy'

GEN_METHODS = [*(METHODS['core']['gen']), *(METHODS['extra']['gen'])]
NON_GEN_METHODS =
  [*(METHODS['core']['non_gen']), *(METHODS['extra']['non_gen'])]

describe Lumberjack::Easy do
  let(:loggen) { Lumberjack.new(STDOUT); }
  let(:nonlog) { Lumberjack.new('/dev/null'); }

  it 'creates distinct/unique instance' do
    expect(loggen).not_to eq nonlog
  end

  describe 'basic capabilities' do
    context 'methods provisioned' do
      shared_examples 'honours method' do |type, method|
        it "#{type.capitalize} capability - #{method}()" do
          method =~ /(::|#)(.*)/
          method = $2
          respondant = $1 == '::' ? Lumberjack : nonlog

          expect(respondant).to respond_to(method)
        end
      end

      METHODS.keys.each do |type|
        METHODS[type].keys.each do |gen|
          METHODS[type][gen].each do |method|
            include_examples 'honours method', type, method
          end
        end
      end
    end
  end

  describe 'Logging levels' do
    context '#levels()' do
      it "doesn't throw" do
        expect { nonlog.levels }.not_to raise_error
        expect { nonlog.levels(true) }.not_to raise_error
      end

      it "returns a non-empty list" do
        expect(nonlog.levels).not_to be_empty
      end
      
      it "the returned list is sorted" do
        expect(nonlog.levels.sort).to match_array(nonlog.levels(true))
      end
    end

    context "generated messages" do
      shared_examples_for 'threshold observer' do  |level, exp_num|
        let(:strio) { StringIO.new }
        let(:logstr) { Lumberjack.new(strio) }

        it "#{level} (#{Lumberjack.const_get(level)}) generates correctly (#{exp_num} lines)" do
          logstr.level = level

          logstr.unknown("This is an unknown msg")
          logstr.fatal("This is an fatal msg")
          logstr.error("This is an error msg")
          logstr.warn("This is an warn msg")
          logstr.info("This is an info msg")
          logstr.entry("This is an entry msg")
          logstr.exit("This is an exit msg")
          logstr.debug("This is an debug msg")
          logstr.trace("This is an trace msg")

          # And test to ensure that only levels equal to, or above, the
          # threshold have been generated - use KISS/JGE to do it solely on
          # line count
          expect(strio.string.split(/\n/).length).to eq exp_num
        end
      end

      describe 'Log level message generation' do
        GEN_METHODS.each do |level|
          level = (level.gsub(/(::|#)(.*)/, '\2')).upcase
          n = Lumberjack.const_get(level)
          it_behaves_like 'threshold observer',
            level, level.to_s =~ /OFF/ ? 0 : 9 - (n <= 2 ? n : n + 1)
        end
      end

      describe "On/off works as expected" do
        let(:strio) { StringIO.new }
        let(:logstr) { Lumberjack.new(strio) }

        it "On resets level to last generating level" do
          logstr.level = Lumberjack::TRACE
          expect(logstr.level).to eq Lumberjack::TRACE
          logstr.off
          logstr.on
          expect(logstr.level).to eq Lumberjack::TRACE
        end

        it "On is idempotent" do
          logstr.level = Lumberjack::TRACE
          # Ensure the level has been saved
          expect(logstr.level).to eq Lumberjack::TRACE
          # "Switch" logging off & back on
          logstr.off
          logstr.on
          # And verify that the level has been restored
          expect(logstr.level).to eq Lumberjack::TRACE
          # and back on again
          logstr.on
          # Once more verifying that the level has been restored
          expect(logstr.level).to eq Lumberjack::TRACE
        end
      end
    end
  end
end

#### END OF FILE
