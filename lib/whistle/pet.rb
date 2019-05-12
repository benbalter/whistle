module Whistle
  class Pet < Hashie::Mash
    def initialize(hash, client: nil)
      @client = client || Whistle.client
      super(hash)
    end

    def timeline
      response = client.request("pets/#{id}/timelines/location")
      response['timeline_items'].map do |t|
        Whistle::TimelineEntry.new(t.symbolize_keys)
      end
    end

    def current_location
      timeline.first
    end

    def time_inside(humanize: false)
      raise StandardError, 'Pet is outside' unless current_location.inside?

      if humanize
        current_location.start_time_ago_in_words
      else
        current_location.start
      end
    end

    private

    attr_reader :client
  end
end
