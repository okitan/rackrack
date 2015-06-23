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
                  # I use BadGatewy to describe no stub matched...
                  not_found do
                    status 502
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
            response = begin
              self.class.stub.call(env)
            rescue Rackrack::Stub::NoStubException
              [ 502, {}, [] ]
            end

            if response.first == 502
              @app.call(env)
            else
              response
            end
          end
        end
      end
    end
  end
end
