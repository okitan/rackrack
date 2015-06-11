require "spec_helper"

require "faraday"

describe Rackrack do
  context ".build_stub" do
    before do
      @stub_server = Rackrack.build_stub(:hoge, ->(env) { [ 404, {}, ["NotFound"] ] })
    end

    let(:client) do
      Faraday.new("http://example.com") do |conn|
        conn.adapter :rack, @stub_server
      end
    end

    context "by default" do
      it "returns 404" do
        expect(client.get("/").status).to eq(404)
        expect(client.get("/").body).to eq("NotFound")
      end
    end

    context "with rack_server" do
      before do
        @stub_server.stub do
          get "/" do
            [ 200, {}, [ "stub_by_rack_server" ] ]
          end
        end
      end
      after do
        @stub_server.reset_stub
      end
      it "returns stub response" do
        expect(client.get("/").status).to eq(200)
        expect(client.get("/").body).to eq("stub_by_rack_server")
      end
    end

    context "with stub" do
      before do
        Rackrack.stubs[:hoge].stub do
          get "/" do
            [ 200, {}, [ "stub" ] ]
          end
        end
      end
      after do
        Rackrack.stubs[:hoge].reset!
      end
      it "returns stub response" do
        expect(client.get("/").status).to eq(200)
        expect(client.get("/").body).to eq("stub")
      end
    end
  end
end
