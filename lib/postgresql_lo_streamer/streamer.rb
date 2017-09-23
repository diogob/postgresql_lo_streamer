class PostgresqlLoStreamer::Streamer
  attr_accessor :connection, :object_identifier

  def initialize(connection, object_identifier)
    @connection = connection
    @object_identifier = object_identifier
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

end
