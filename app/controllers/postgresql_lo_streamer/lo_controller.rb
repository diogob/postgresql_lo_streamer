#encoding: utf-8

module PostgresqlLoStreamer
  class LoController < ActionController::Base
    def stream
      send_file_headers! configuration.options

      object_identifier = params[:id].to_i
      if !object_exists?(object_identifier)
        self.status = 404
        render :nothing => true and return
      end

      self.status = 200
      self.response_body = Enumerator.new do |y|
        connection.transaction do
          lo = connection.lo_open(object_identifier, ::PG::INV_READ)
          while data = connection.lo_read(lo, 4096) do
            y << data
          end
          connection.lo_close(lo)
        end
      end
    end

    def connection
      @con ||= ActiveRecord::Base.connection.raw_connection
    end

    private
      
    def object_exists?(identifier)
      begin
        connection.lo_open(identifier, ::PG::INV_READ)
      rescue PG::Error => e
        if e.to_s.include? "does not exist"
          return false
        end
          
        raise
      end

      return true
    end
      
    def configuration
      PostgresqlLoStreamer.configuration
    end
  end
end
