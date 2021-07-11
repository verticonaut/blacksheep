module Blacksheep
  class ActionResult

    attr_reader :data, :status

    @render_http_status = true

    def initialize(data, status)
      @data = data
      @status = status
    end

    class << self
      attr_accessor :render_http_status

      def success(message)
        json = {
          _meta: {
            message: message
          }
        }

        new(json, :ok)
      end

      def error(title: 'Error', message:, status: :internal_server_error, pointer: 'unspecified')
        json = {
          errors: [
            pointer: {
              source: pointer
            },
            title: title,
            detail: message,
          ]
        }
        status = :internal_server_error

        new(json, status)
      end
    end

    def set_data(value)
      @data = value

      self
    end

    def set_status(value)
      @status = value

      self
    end

    def success?
      @status == :ok
    end

    def success_message(message)
      meta = json.fetch(:_meta) { |_key| json[:_meta] = {}; json[:_meta] }
      meta[:message] = message

      self
    end

    def render_http_status
      self.class.render_http_status
    end

    def render_json(json_wrap: 'data', render_http_status: self.render_http_status, to: nil)
      if to.nil?
        return {
          json: wrap_json(json_wrap)
        }
      end

      if to.respond_to?(:render)
        if render_http_status
          to.render json: wrap_json(json_wrap), status: status
        else
          to.render json: wrap_json(json_wrap)
        end
      else
        raise ArgumentError, "render target #{to.class} does not respond to #render"
      end
    end

    private

    def wrap_json(json_wrap)
      json_wrap.present? && success? ? { json_wrap => @data } : @data
    end

  end
end