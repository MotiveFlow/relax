require 'spec_helper'

describe Relax::Config do
  {
    USER_AGENT: "Relax Ruby Gem Client #{Relax::VERSION}",
    TIMEOUT: 60
  }.each do |constant, value|
    context "::#{constant}" do
      subject { described_class.const_get(constant) }

      it { should == value }
    end
  end

  context '.new' do
    subject { described_class.new }

    context 'defaults' do
      it 'is a Faraday default adapter' do
        expect(subject.adapter).to be_a Faraday.default_adapter.class
      end

      it 'has a nil base_uri' do
        expect(subject.base_uri).to be_nil
      end

      it 'has a timeout of 60' do
        expect(subject.timeout).to eq 60
      end

      it 'has a user_agent that reflect the relax version' do
        expect(subject.user_agent).to eq "Relax Ruby Gem Client #{Relax::VERSION}"
      end
    end
  end
end
