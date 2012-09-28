Rails.application.routes.draw do

  mount PostgresqlLoStreamer::Engine => "/postgresql_lo_streamer"
end
