module Blacksheep
  module Decorators

    # @class Blacksheep::Decorators::Localizer
    class Localizer < ActionDecorator

      def call(params, current_user: nil, **options)
        if (locale = params[:_locale])
          I18n.with_locale(locale) do
            super
          end
        else
          super
        end
      end

      def perform(params, current_user: nil, **options)

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
