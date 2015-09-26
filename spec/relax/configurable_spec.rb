require 'spec_helper'

describe Relax::Configurable do
  let(:configurable) { Class.new { include Relax::Configurable }.new }

  subject { configurable }

  context '#config' do
    it 'returns an instance of Relax::Config' do
      expect(subject.config).to be_a(Relax::Config)
    end

    it 'memoizes the configuration' do
      expect(subject.config).to eq subject.config
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
      expect(subject.configure { }).to eq configurable
    end
  end
end
