
RSpec.describe 'Logger extension' do
  before(:each) do
    @logger = Logger.new('/dev/null')
  end

  it 'compiles/requires OK' do
    expect {
      require 'extensions/standard/logger'
    }.not_to raise_error

  end

  require 'extensions/standard/logger'

  context 'responds to extensions' do
    describe 'log generation' do
      %w(trace entry exit).each do |m|
        ['', '?', '!'].each do |p|
          _m = "#{m}#{p}"

          it "responds to ##{_m}*" do
            expect(@logger).to respond_to(:"#{_m}")
          end

          it "#{_m} doesn't throw" do
            if _m =~ /[!?]$/
              expect { @logger.send(:"#{_m}") }.not_to raise_error
            else
              expect { @logger.send(:"#{_m}", '') }.not_to raise_error
            end
          end
        end
      end
    end

    describe 'control' do
      [ :on, :off, :levels ].each do |m|
        it "responds to ##{m}" do
          expect(@logger).to respond_to(m)
        end
      end
    end
  end
end

#### END OF FILE
