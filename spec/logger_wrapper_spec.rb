require 'logger_wrapper'

class LoggerWrapperTest
  require 'logger_wrapper'
  #extend LoggerWrapper
  #include LoggerWrapper

  def self.cl_qual_unknown
    $Logger.unknown 'msg'
  end

  def inst_qual_unknown
    $Logger.unknown 'msg'
  end
end

RSpec.describe LoggerWrapper do
  #include LoggerWrapper

  describe 'Global variable ($Logger)' do
    it 'Non-nil' do
      expect($Logger).not_to eq nil
    end

    it 'Correct class' do
      expect($Logger).to be_kind_of Logger
    end
  end

  describe 'Method access' do
    (Logger.instance_methods - Object.methods).each do |l|
      it "LoggerWrapperTest.respond_to?(#{l})" do
        expect(LoggerWrapperTest.respond_to?(l)).to be Logger.respond_to?(l)
      end

      it "$Logger.respond_to?(#{l})" do
        expect($Logger.respond_to?(l)).to be true
      end
    end
  end

  describe 'threshold setting and recovery' do
    it 'setting threshold works' do
      expect($Logger.level()).to eq Logger::DEBUG
    end
  end

  describe 'Enable/disable logging' do
    it 'Non-nil object' do
      expect($Logger).not_to eq nil
    end

    # Redirect to/capture in the log file
    #$Logger.reopen('log')

    # Set minimum threshold
    #STDERR.puts "#{$Logger}, #{Logger::DEBUG}, #{$Logger.level}, #{Logger.new(STDERR)}"
    $Logger.level = Logger::DEBUG
    #STDERR.puts "#{$Logger}, #{Logger::DEBUG}, #{$Logger.level}"
    @level = $Logger.level
    #raise "#{@level}"

    describe 'off() disables log reporting' do
      it 'calls to $Logger.off() do not die' do
        expect { $Logger.off() }.not_to raise_error
      end

      it 'updates logging state - to disabled' do
        expect($Logger.enabled()).to eq false
      end

      describe 'subsequent severity calls produce nothing' do
        # Firstly, ensure the log file exists and is empty
        `> log`

        %w(unknown fatal error warn info debug).each do |l|
          it "sev level:: #{l}" do
            $Logger.send(l, 'wtaf')
            nm = l == 'unknown' ? 'any' : l
            puts "##{`cat log`}#"
            `grep -i "#{nm} .*wtaf" log`
            expect($?.exitstatus()).to eq 1
          end
        end
      end
    end

    describe 'on() re-enables log reporting' do
      it 'calls to $Logger.on() do not die' do
        expect { $Logger.on() }.not_to raise_error
      end

      it 'updates logging state - to enabled' do
        expect($Logger.enabled()).to eq true
      end

      it 're-enabling does not affect the threshold' do
        expect($Logger.level()).to eq Logger::DEBUG
      end

      describe 'subsequent severity calls produce something' do
        # Firstly, ensure the log file exists and is empty
        `> log`

        %w(unknown fatal error warn info debug).each do |l|
          it "sev level:: #{l}" do
            $Logger.send(l, 'wtaf')
            nm = l == 'unknown' ? 'any' : l
            `grep -i "#{nm} .*wtaf" log`
            expect($?.exitstatus()).to eq 0
          end
        end
      end
    end
  end

  describe 'calls to unknown()' do
    it 'cl_qual_unknown' do
      expect { LoggerWrapperTest.cl_qual_unknown }.not_to raise_error
    end

    it 'inst_qual_unknown' do
      expect { LoggerWrapperTest.new().inst_qual_unknown }.not_to raise_error
    end
  end
end

