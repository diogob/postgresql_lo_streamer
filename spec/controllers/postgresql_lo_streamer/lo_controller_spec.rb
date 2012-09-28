require 'spec_helper'

describe PostgresqlLoStreamer::LoController do
  subject{ response }
  describe "GET stream" do
    before do
      get :stream, :id => 1
    end
    its(:status){ should == 200 }
  end
end
