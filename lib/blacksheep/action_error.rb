module Blacksheep
  #
  # @class Blacksheep::ActionError
  class ActionError < StandardError
    attr_reader :identifier, :title

    def initialize(message, title: 'Error', identifier: 'undefined', status: :internal_server_error)
      @identifier = identifier
      @title = title
      @status = status

      super(message)
    end

  end
end
