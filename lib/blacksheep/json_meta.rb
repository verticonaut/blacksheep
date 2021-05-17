module Blacksheep
  class JsonMeta

    attr_reader :json

    def initialize(json = {})
      @json = json
    end

    class << self
      def success(title: nil, detail: nil)
        new.success(title: title, detail: detail)
      end
    end

    def success(title: nil, detail: nil)
      result = {
        success: true,
      }

      if title.present?
        result[:title] = title
      elsif detail.present?
        result[:title] = 'Success'
      end

      result[:detail] = detail if detail.present?

      json[:result] = result

      self
    end

    def as_json
      {
        jsonMeta: json
      }
    end

  end
end