require 'rails_helper'

describe PostgresqlLoStreamer::LoController do
  routes { PostgresqlLoStreamer::Engine.routes }

  subject { response }
  let(:connection) { ActiveRecord::Base.connection.raw_connection }
  let(:file_content) { File.open("#{ENGINE_RAILS_ROOT}/spec/fixtures/test.jpg").read }


  describe "#connection" do
    subject { PostgresqlLoStreamer::LoController.new.connection }
    it { should == ActiveRecord::Base.connection.raw_connection }
  end

  describe "GET stream" do
    before do
      expect(controller).to receive(:send_file_headers!).with({:type => "image/png", :disposition => "inline"})
      connection.transaction do
        @oid = connection.lo_creat
        lo = connection.lo_open(@oid, ::PG::INV_WRITE)
        size = connection.lo_write(lo, file_content)
        connection.lo_close(lo)
      end
      get :stream, :id => @oid
    end

    after do
      connection.lo_unlink(@oid)
    end

    its(:body) { should == file_content }
    its(:status) { should == 200 }
  end

  describe "GET non-existing stream" do
    before do
      expect(controller).to receive(:send_file_headers!).with({:type => "image/png", :disposition => "inline"})
      get :stream, :id => 9999
    end

    its(:body) { should be_blank }
    its(:status) { should == 404 }
  end
end
