#encoding: utf-8

module PostgresqlLoStreamer
  class LoController < ActionController::Base
    def stream
      send_file_headers!(headers_for_extension_or_default)

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

    def headers_for_extension_or_default
      #extension provided and recognized
      #Mime is built into rails
      if params[:format].present? && Mime::Type.lookup_by_extension(params[:format]).present?
        type = Mime::Type.lookup_by_extension(params[:format]).to_s
        {type: type, disposition: disposition_from_type(type) }
      else
        configuration.options #fallback
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

  end
end
