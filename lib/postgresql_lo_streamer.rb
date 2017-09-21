require "postgresql_lo_streamer/engine"
require "postgresql_lo_streamer/configuration"
require "postgresql_lo_streamer/streamer"

module PostgresqlLoStreamer
  class << self
    def configure
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end
end
