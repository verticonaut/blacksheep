module Blacksheep
  class ActionResult

    attr_reader :data, :status

    def initialize(data, status)
      @data = data
      @status = status
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

    def render_json(json_wrap: 'data')
      {
        json:   wrap(@data, json_wrap: json_wrap),
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