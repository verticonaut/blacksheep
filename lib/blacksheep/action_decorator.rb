require 'delegate'

module Blacksheep
  class ActionDecorator < SimpleDelegator
    def class
      __getobj__.class
    end
  end
end
