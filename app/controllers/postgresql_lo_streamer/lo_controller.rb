#encoding: utf-8

module PostgresqlLoStreamer
  class LoController < ActionController::Base

    def stream

      streamer = PostgresqlLoStreamer::Streamer.new(
        connection,
        params[:id].to_i
      )
      send_file_headers!(default_headers_for(params[:format]))
      if !streamer.object_exists?
        head 404, default_headers_for(params[:format])
        return
      end
      self.status = 200
      self.response_body = streamer.stream

    end

    def connection
      @con ||= ActiveRecord::Base.connection.raw_connection
    end

    private

    def default_headers_for(extension)
      if extension.present? && Mime::Type.lookup_by_extension(extension).present?
        type = Mime::Type.lookup_by_extension(extension).to_s
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

    def configuration
      PostgresqlLoStreamer.configuration
    end

  end
end
