require "rackrack/builder"
require "rackrack/stub"

module Rackrack
  class << self
    def stubs
      @stubs ||= {}
    end

    def build_stub(name, app = ->(env) { [ 404, {}, [] ] }, &block)
      Builder.new(name, stub: true, app: app, &block)
    end
  end
end
