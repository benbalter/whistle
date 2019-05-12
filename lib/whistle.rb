require 'dotenv/load'
require 'typhoeus'
require 'addressable/uri'
require 'logger'
require 'action_view'
require 'time'
require 'hashie'
require 'json'

module Whistle
  class BadResponse < StandardError; end

  autoload :Cache,         'whistle/cache'
  autoload :Client,        'whistle/client'
  autoload :Pet,           'whistle/pet'
  autoload :TimelineEntry, 'whistle/timeline_entry'
  autoload :Version,       'whistle/version'

  Typhoeus::Config.cache = Cache.new

  BASE = Addressable::URI.parse('https://app.whistle.com/api/')
  DEFAULT_TYPHOEUS_ARGS = {
    headers: {
      'Content-Type' => 'application/json',
      'Accept' => 'application/vnd.whistle.com.v4+json'
    }
  }.freeze

  class << self
    attr_writer :client, :logger

    def client
      @client ||= Client.new
    end

    def logger
      @logger ||= begin
        logger = Logger.new(STDOUT)
        logger.level = Logger::WARN
        logger
      end
    end
  end
end
