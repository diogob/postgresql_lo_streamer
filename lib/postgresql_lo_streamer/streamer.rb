class PostgresqlLoStreamer::Streamer
  attr_accessor :connection, :object_identifier, :format

  def initialize(connection, object_identifier, extension = nil)
    @connection = connection
    @object_identifier = object_identifier
    @format = extension
  end

  def default_headers
    if @format.present? && Mime::Type.lookup_by_extension(@format).present?
      type = Mime::Type.lookup_by_extension(@format).to_s
      {type: type, disposition: disposition_from_type(type) }
    else
      configuration.options #fallback
    end
  end

  def object_exists?
    begin
      @connection.lo_open(@object_identifier, ::PG::INV_READ)
    rescue PG::Error => e
      if e.to_s.include? "does not exist"
        return false
      end
      raise
    end
    return true
  end

  def stream
    return Enumerator.new do |y|
      @connection.transaction do
        lo = @connection.lo_open(@object_identifier, ::PG::INV_READ)
        while data = connection.lo_read(lo, 4096) do
          y << data
        end
        @connection.lo_close(lo)
      end
    end
  end

  def disposition_from_type(type)
    inline_types = [
      "image/jpeg",
      "image/png",
      "image/gif",
      "image/svg+xml",
      "text/css",
      "text/plain"
    ]
    case type
    when *inline_types
      "inline"
    else
      "attachment" #fallback
    end
  end

  def configuration
    PostgresqlLoStreamer.configuration
  end
end
