module Blacksheep
  module Decorators
    # @class Blacksheep::Decorators::DefaultErrorHandler
    class DefaultErrorHandler < ActionDecorator
      include ErrorHandler

      def handle(exception)
        json = status = nil

        # case exception
        #   when Exceptions::ValidationException
        #     errors = []
        #     exception.model.errors.each do |attribute, message|
        #       errors << {
        #         title:  "'#{attribute}' validation error",
        #         detail: message,
        #       }
        #     end
        #     json = {
        #       errors: errors
        #     }
        #     status = :unprocessable_entity # 422
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
        #   else
        #     json = {
        #       errors: [
        #         pointer: {
        #           source: 'Internal'
        #         },
        #         title: "#{exception.class}",
        #         detail: "#{exception.message}",
        #       ]
        #     }
        #     status = :internal_server_error # 500
        # end

        json = {
          errors: [
            pointer: {
              source: 'Internal'
            },
            title: "#{exception.class}",
            detail: "#{exception.message}",
          ]
        }
        status = :internal_server_error # 500

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