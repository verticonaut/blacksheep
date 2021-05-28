module Blacksheep
  #
  # @class Blacksheep::ActionError
  class ActionError < StandardError
    attr_reader :identifier, :title

    def initialize(message, title: 'Error', identifier: 'undefined')
      @identifier = identifier
      @title = title

      super(message)
    end

  end
end
