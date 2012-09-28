require 'spec_helper'

describe PostgresqlLoStreamer::LoController do
  subject{ response }
  describe "GET stream" do
    before do
      get :stream, :id => 1, :use_route => :postgresql_lo_streamer
    end
    its(:status){ should == 200 }
  end
end
