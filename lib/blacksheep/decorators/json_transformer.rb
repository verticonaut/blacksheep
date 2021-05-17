module Blacksheep
  module Decorators
    # @class Blacksheep::Decorators::JsonTransformer
    class JsonTransformer < ActionDecorator

      attr_reader :case, :params

      def call(params, **options)
        puts transformer: "*" * 50
        detect_case(params)

        transformed_params = self.transformed_params(params)

        json = super(transformed_params, **options)

        transformed_json = transform_result(json)

        JsonResult.new(transformed_json, :ok)
      end

      def perform(params, current_user: nil, **options, &block)
        detect_case(params)

        transformed_params = self.transformed_params(params)

        json = block.call(transformed_params)
        transformed_json = transform_result(json)

        JsonResult.new(transformed_json, :ok)
      end


      #
      # Transform the params in the instance into snake_case - if detected - from source.
      #
      # @return [Array, Hash] The params converted into snake_case
      # @see #snakecase_keys
      def transformed_params(params)
        case @case
          when 'snake', 'as_is'
            params
          when 'camel'
            snakecase_keys(params)
          else
            raise Blackseep::Error, "unknown_case #{@case}"
        end
      end

      #
      # Transform the obj with key in snake_case to the source case.
      # NOTE: leading underscored are preserved (e.g. _my_laptop => _myLaptop)
      #
      # @param obj [Array, Hash] A result structure
      # @return [Array, Hash] The rsult structure with keys converted to source caseing
      # @see #camelize_keys
      def transform_result(obj)
        case @case
          when 'snake', 'as_is'
            obj
          when 'camel'
            camelize_keys(obj)
          else
            raise Blackseep::Error, "unknown_case #{@case}"
        end
      end

      #
      # Make all keys in the passed object snake_case
      #
      # @param obj [Array, Hash] …
      # @return [Array, Hash] The source obj with kyes transformed into snake_case
      def snakecase_keys(obj)
        deep_transform_keys(obj) { |k| k.to_s.underscore.to_sym }.with_indifferent_access
      end

      #
      # Camlize keys - but keep leading underscores
      #
      # @param obj [Array, hash] …
      # @return [Array, Hash] The passed in obj with keys transferred to camel_case.
      def camelize_keys(obj)
        deep_transform_keys(obj) { |k|
          key = k.to_s
          match = key.match(/^(?<underscores>_*)(?<attribute>\w*)/)
          converted = match[:attribute].camelize(:lower)

          match[:underscores].present? ? "#{match[:underscores]}#{converted}" : converted
        }
      end

      private

      def detect_case(params)
        @params ||= params
        @case ||= params ? params.fetch(:_case, 'as_is').to_s : 'as_is'

        @case
      end

      #
      # Deep transform the keys in the obj structure as descibed in the block passed
      #
      # @param obj [Array, Hash] …
      # @yield key [String] A block transforming the key passed into
      # @yield_param key [String, Symbol] The key to be transformed
      # @yield_return [String] The transfomed key
      # @return [Array, Hash] The obj structure with transformed keys.
      def deep_transform_keys(obj, &block)
        case obj
          when  Hash, ActionController::Parameters
            res = {}.with_indifferent_access
            obj.each do |key, value|
              res[yield(key)] = deep_transform_keys(value, &block)
            end
            res
          when Array
            obj.map{ |each| deep_transform_keys(each, &block) }
          else
            obj
        end
      end


    end
  end
end