require 'spec_helper'

describe PostgresqlLoStreamer::LoController do
  subject{ response }
  let(:connection){ ActiveRecord::Base.connection.raw_connection }
  let(:file_content){ File.open("#{ENGINE_RAILS_ROOT}/spec/fixtures/test.jpg").read }


  describe "#connection" do
    subject{ PostgresqlLoStreamer::LoController.new.connection }
    it{ should == ActiveRecord::Base.connection.raw_connection }
  end

  describe "GET stream" do
    before do
      controller.should_receive(:send_file_headers!)
      connection.transaction do
        @oid = connection.lo_creat
        lo = connection.lo_open(@oid, ::PG::INV_WRITE)
        size = connection.lo_write(lo, file_content)
        connection.lo_close(lo)
      end
      get :stream, :id => @oid, :use_route => :postgresql_lo_streamer
    end

    after do
      connection.lo_unlink(@oid)
    end

    its(:body){ should == file_content }
    its(:status){ should == 200 }
  end
end
