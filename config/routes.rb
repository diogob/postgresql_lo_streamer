PostgresqlLoStreamer::Engine.routes.draw do
  get ":id" => "lo#stream"
end
