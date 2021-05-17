require "dry-matcher"

module Blacksheep
  module Decorators
    # @class Blacksheep::Decorators::ResultMatcher
    class ResultMatcher < ActionDecorator
      Matcher = -> {
        # Match `json_result` with status :ok for success
        success_case = Dry::Matcher::Case.new do |json_result, _|
          if json_result.success?
            json_result
          else
            # this is a constant from dry/core/constants
            Dry::Matcher::Undefined
          end
        end

        # Match `json_result` with status not :ok` for failure - other status' can be distinguished
        failure_case = Dry::Matcher::Case.new do |json_result, patterns|
          if !json_result.success! && (patterns.empty? || patterns.include?(json_result.status))
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
        puts matcher: "*" * 50
        super
      end

      def perform(*)
        raise Blackseep::Error, 'JsonResultMatcher does not support #perform'
      end

    end
  end
end