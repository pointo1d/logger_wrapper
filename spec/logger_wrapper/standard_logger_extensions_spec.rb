
RSpec.describe 'Logger extension' do
  it 'compiles/requires OK' do
    expect {
      require 'extensions/standard/logger'
    }.not_to raise_error

  end

  require 'extensions/standard/logger'

  context 'API is extended i.e. as was + extensions' do
    describe 'log generation associated methods' do
      %w(
        trace debug entry exit info warn error fatal unknown
      ).each do |m|
        before(:each) do
          @logger = Logger.new('/dev/null')
        end

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

    describe 'logging control methods' do
      [
        :on, :off
      ].each do |m|
        before(:each) do
          @logger = Logger.new('/dev/null')
        end

        it "responds to ##{m}" do
          expect(@logger).to respond_to(m)
        end
      end
    end
  end
end

#### END OF FILE
