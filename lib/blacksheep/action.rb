module Blacksheep
  # Transoformes key in object structures in different caseing (snake_case, pascal_case cucrrently)
  #
  # @example
  #   params = {
  #     attr: 1,
  #     _case: 'camel'
  #   }
  #
  #   result_in_camel_case = Blacksheep::JsonTransformer.new(params).process_transformed do |converted_params_in_snake_case|
  #     do_something_with(converted_params_in_snake_case)
  #     #…
  #   end
  #
  #   …alternative
  #   transformer = Blacksheep::JsonTransformer.new(params)
  #   converted_params_in_snake_case = transformer.transformed_params
  #   ...
  #   result = do_something_with(converted_params_in_snake_case)
  #   result_in_camel_case = transformer.transform_result(result)
  #
  # @class Blacksheep::Action
  class Action
    attr_reader :params, :current_user, :options

    class << self
      def decorators
        @@decorators ||= []
      end

      #
      # Adds a decorator to the list of decorated to be applied on Balcksheep::Actions
      # @param decorator [type] [description]
      #
      # @return [type] [description]
      def add_decorator(decorator)
        decorators << decorator unless decorators.include?(decorator)
      end

      def new(*arguments, &block)
        instance = super

        decorators.each do |decorator|
          instance = decorator.new(instance)
        end

        instance
      end
    end

    def call(params, current_user: nil, **options)
      @params = params
      @current_user = current_user
      @options = options
    end

    def perform(params, current_user: nil, **options, &block)
      @params = params
      @current_user = current_user
      @options = options

      block.call(params)
    end

    def action_result(data, status: :ok)
      ActionResult.new(data, status)
    end

  end
end
