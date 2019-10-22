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

RSpec.describe 'LoggerWrapper Usage' do
  it 'requirer lives' do
    expect($Logger).not_to eq nil
    l = $Logger
    expect { class Requirer require 'logger_wrapper'; end }.not_to raise_error
    expect $Logger == l
  end
  
  it 'subclasser lives' do
    expect($Logger).not_to be nil
    l = $Logger
    expect { class SubClasser < LoggerWrapper; end }.not_to raise_error
    expect $Logger == l
  end
end

