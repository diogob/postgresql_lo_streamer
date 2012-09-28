#encoding: utf-8

module PostgresqlLoStreamer
  class LoController < ActionController::Base
    def stream
      return render :nothing => true, :status => 200
    end
  end
end
