#encoding: utf-8

module PostgresqlLoStreamer
  class LoController < ActionController::Base

    def stream

      streamer = PostgresqlLoStreamer::Streamer.new(
        ActiveRecord::Base.connection.raw_connection,
        params[:id].to_i,
        params[:format]
      )
      send_file_headers!(streamer.default_headers)
      if !streamer.object_exists?
        head 404, streamer.default_headers
        return
      end
      self.status = 200
      self.response_body = streamer.stream

    end

  end
end
