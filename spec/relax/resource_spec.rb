require 'spec_helper'

describe Relax::Resource do
  let(:client) do
    Class.new do
      include Relax::Client

      def initialize
        config.base_uri = 'http://api.example.com/v2'
      end
    end.new
  end

  let(:resource_class) { Class.new { include Relax::Resource } }

  subject { resource_class.new(client) }

  context '.new' do
    it 'accepts an options hash' do
      resource_class.new(client, key: :value)
    end
  end

  context '#connection' do
    let(:connection) { subject.send(:connection) }

    it 'returns an instance of Faraday::Connection' do
      expect(connection).to be_a(Faraday::Connection)
    end

    it 'uses the configured base URI as the URL' do
      expect(connection.url_prefix).to eq URI.parse(client.config.base_uri)
    end

    it 'uses the configured timeout' do
      expect(connection.options[:timeout]).to eq client.config.timeout
    end

    it 'accepts an options hash to be passed to Faraday::Connection' do
      headers = { user_agent: "#{described_class} Test" }
      connection = subject.send(:connection, headers: headers)
      expect(connection.headers['User-Agent']).to eq headers[:user_agent]
    end

    it 'yields a builder to allow the middleware to be customized' do
      expect(subject.send(:connection) do |builder|
        builder.use(Faraday::Response::Logger)
      end.builder.handlers).to include(Faraday::Response::Logger)
    end
  end

  context 'connection delegation' do
    let(:connection) { double(:connection) }

    before { allow(subject).to receive(:connection).and_return(connection) }

    Faraday::Connection::METHODS.each do |method|
      it "delegates ##{method} to #connection" do
        expect(connection).to receive(method)
        subject.send(method)
      end
    end
  end
end
