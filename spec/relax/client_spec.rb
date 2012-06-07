require 'spec_helper'

describe Relax::Client do
  let(:client) { Class.new { include Relax::Client }.new }

  subject { client }

  context '#config' do
    it 'returns an instance of Relax::Config' do
      subject.config.should be_a(Relax::Config)
    end

    it 'memoizes the configuration' do
      subject.config.should == subject.config
    end
  end

  context '#configure' do
    it 'yields an instance of the configuration' do
      expect {
        subject.configure do |config|
          config.base_uri = 'http://api.example.com/v2'
        end
      }.to change(subject.config, :base_uri).to('http://api.example.com/v2')
    end

    it 'returns self' do
      subject.configure { }.should == client
    end
  end
end
