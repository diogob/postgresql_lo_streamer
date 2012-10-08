#encoding: utf-8

module PostgresqlLoStreamer
  class LoController < ActionController::Base
    def stream
      # TODO: make this headers configurable
      send_file_headers!({:type => 'image/png', :disposition => 'inline'})
      self.status = 200
      self.response_body = Enumerator.new do |y|
        connection.transaction do
          lo = connection.lo_open(params[:id].to_i, ::PG::INV_READ)
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
  end
end
