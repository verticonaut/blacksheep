module Blacksheep
  module Decorators
    # @class Blacksheep::Decorators::DefaultErrorHandler
    class DefaultErrorHandler < ActionDecorator
      include ErrorHandler

      def handle(exception)
        json = nil
        status = :internal_server_error

        case exception
          when Blacksheep::ActionError
            json = {
              errors: [
                pointer: {
                  source:  exception.backtrace.first,
                  identifier: exception.identifier,
                },
                title: exception.title,
                detail: exception.message,
              ]
            }

            #   when Pundit::NotAuthorizedError
            #     json = {
            #       errors: [
            #         pointer: {
            #           source: not_authorized_pointer(exception)
            #         },
            #         title: "#{exception.class}",
            #         detail: "#{exception.message}",
            #       ]
            #     }
            #     status = :unauthorized # 401
            #   when Exceptions::AuthenticationInvalid
            #     json = {
            #       errors: [
            #         pointer: {
            #           source: 'Secured Module'
            #         },
            #         title: "#{exception.class}",
            #         detail: "#{exception.message}",
            #       ]
            #     }
            #     status = :unauthorized # 401

          else
            json = {
              errors: [
                pointer: {
                  source: 'Internal'
                },
                title: "#{exception.class}",
                detail: "#{exception.message}",
              ]
            }
        end

        ActionResult.new(json, status)
      end

      # def not_authorized_pointer(exception)
      #   if exception.record
      #     "#{record.class}.find #{record.id}"
      #   else
      #     exception.message
      #   end
      # end

    end
  end
end