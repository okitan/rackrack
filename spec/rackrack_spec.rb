require "spec_helper"

require "faraday"

describe Rackrack do
  context ".build_stub" do
    before do
      @stub_server = Rackrack.build_stub(:hoge, ->(env) { [ 404, {}, ["No Route Matched"] ] })
    end

    let(:client) do
      Faraday.new("http://example.com") do |conn|
        conn.adapter :rack, @stub_server
      end
    end

    context "by default" do
      it "returns 404" do
        expect(client.get("/").status).to eq(404)
        expect(client.get("/").body).to eq("No Route Matched")
      end
    end

    context "with rack_server" do
      let(:response) { "stub_by_rack_server" }
      before do
        _response = response
        @stub_server.stub do
          get "/" do
            [ 200, {}, [ _response ] ]
          end
          get "/not_found" do
            [ 404, {}, [ "not_found" ] ]
          end
        end
      end
      after do
        @stub_server.reset_stub
      end
      it "returns stub response" do
        expect(client.get("/").status).to eq(200)
        expect(client.get("/").body).to eq(response)
      end
      it "returns stub response for 404 response" do
        expect(client.get("/not_found").status).to eq(404)
        expect(client.get("/not_found").body).to eq("not_found")
      end
      it "returns default response for not routed path" do
        expect(client.get("/not_routed").status).to eq(404)
        expect(client.get("/not_routed").body).to eq("No Route Matched")
      end
    end
  end
end
