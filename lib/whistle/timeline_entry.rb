# Represents a timeline entry hash as an object, e.g., entry.start
module Whistle
  class TimelineEntry < Hashie::Dash
    include Hashie::Extensions::Dash::PropertyTranslation
    include Hashie::Extensions::Coercion
    include ActionView::Helpers::DateHelper

    property :start, from: :start_time, with: ->(v) { Time.parse(v) if v }
    property :end, from: :end_time, with: ->(v) { Time.parse(v) if v }
    property :type
    property :data
    coerce_key :type, Symbol

    def inside?
      type == :inside
    end

    def outside?
      type == :outside
    end

    def start_time_ago_in_words
      time_ago_in_words(start)
    end
  end
end
