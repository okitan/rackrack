require "sinatra/base"

module Rackrack
  module Stub
    class NoStubException < Exception; end

    class << self
      def build(&block)
        Class.new do
          class << self
            def stub(&block)
              if block_given?
                @stub = Class.new(Sinatra::Base) do
                  instance_eval(&block)
                  error 404 do
                    raise Rackrack::Stub::NoStubException
                  end
                end
              else
                @stub ||= raise Rackrack::Stub::NoStubException
              end
            end

            def reset!
              @stub = nil
            end
          end

          def initialize(app)
            @app = app
          end

          def call(env)
            begin
              self.class.stub.call(env)
            rescue Rackrack::Stub::NoStubException
              @app.call(env)
            end
          end
        end
      end
    end
  end
end
