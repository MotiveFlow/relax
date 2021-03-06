require 'faraday'

module Relax
  module Resource
    extend Forwardable

    delegate Faraday::Connection::METHODS => :connection
    private *Faraday::Connection::METHODS

    def initialize(client, options={})
      @client = client
      @options = options
    end

    def connection(options={})
      options[:url] ||= config.base_uri
      (options[:headers] ||= {})[:user_agent] ||= config.user_agent
      (options[:request] ||= {})[:timeout] ||= config.timeout

      Faraday.new(options) do |builder|
        yield(builder) if block_given?
        builder.adapter(config.adapter)
      end
    end
    private :connection

    def config
      @client.config
    end
    private :config
  end
end
