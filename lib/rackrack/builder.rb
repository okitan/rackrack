require "rack"

require "rackrack/stub"

require "delegate"

module Rackrack
  class Builder < SimpleDelegator
    def initialize(name, stub: false,
                   app: ->(env) { [ 404, {}, [] ] }, &block)
      @stub = (stub &&= Stub.build)

      @app = Rack::Builder.app do
        use stub if stub
        run app
      end
      super(@app)
    end

    def stub(&block)
      @stub.stub(&block)
    end

    def reset_stub
      @stub.reset!
    end
  end
end
