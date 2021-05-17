module Blacksheep
  module Decorators

    # @class Blacksheep::Decorators::Localozer
    class Localizer < ActionDecorator

      def call(params, **)
        if (locale = params[:_locale])
          I18n.with_locale(locale) do
            super
          end
        else
          super
        end
      end

      def perform(params, **)
        if (locale = params[:_locale])
          I18n.with_locale(locale) do
            super
          end
        else
          super
        end
      end

    end

  end
end
