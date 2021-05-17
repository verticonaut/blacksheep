module Blacksheep
  class JsonResult

    attr_reader :json, :status

    def initialize(json, status)
      @json = json
      @status = status
    end

    def set_json(value)
      @json = value

      self
    end

    def set_status(value)
      @status = value

      self
    end

    def success?
      @status == :ok
    end

    def render(json_wrap: 'data')
      {
        json:   wrap(json, json_wrap: json_wrap),
        status: status
      }
    end

    private

    def wrap(json, json_wrap:)
      wrap = success? ? json_wrap : nil

      wrap.present? ? { wrap => json } : json
    end

  end
end