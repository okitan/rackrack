require "rack"
require "rackrack/stub"

module Rackrack
  class << self
    def stub(name, &block)
      stubs[name].stub(&block)
    end

    def stubs
      @stubs ||= {}
    end

    def build_stub(name, app = ->(env) { [ 404, {}, [] ] }, &block)
      stubs[name] = stub = Rackrack::Stub.build

      Rack::Builder.app do
        use stub
        run app
      end
    end
  end
end
