require "dry-matcher"

module Blacksheep
  module Decorators
    # @class Blacksheep::Decorators::ResultMatcher
    class ResultMatcher < ActionDecorator
      Matcher = -> {
        # Match `action_result` with status :ok for success
        success_case = Dry::Matcher::Case.new do |action_result, _|
          if action_result.success?
            action_result
          else
            # this is a constant from dry/core/constants
            Dry::Matcher::Undefined
          end
        end

        # Match `action_result` with status not :ok` for failure - other status' can be distinguished
        failure_case = Dry::Matcher::Case.new do |action_result, patterns|
          if !action_result.success! && (patterns.empty? || patterns.include?(action_result.status))
            value
          else
            Dry::Matcher::Undefined
          end
        end

        # Build the matcher
        Dry::Matcher.new(success: success_case, failure: failure_case)
      }.call

      include Dry::Matcher.for(:call, with: Matcher)

      def call(*)
        super
      end

      def perform(*)
        raise Blacksheep::Error, 'ResultMatcher does not support #perform'
      end

    end
  end
end