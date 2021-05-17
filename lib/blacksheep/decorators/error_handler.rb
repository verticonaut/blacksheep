module Blacksheep
  module Decorators
    # @class Blacksheep::Decorators::ErrorHandler
    class ErrorHandler

      def call(*)
        super
      rescue => exception
        handle(exception)
      end

      def perform(*)
        super
      rescue => exception
        handle(exception)
      end

      def handle(exception)
        raise Blacksheep::Error, 'Subclass responsibility'
      end

    end
  end
end