require 'delegate'

module Blacksheep
  # @class Blacksheep::ActionDecorator
  class ActionDecorator < SimpleDelegator

    # Access to the decorators class - since original class is overwritten to return the model class.
    #
    # @return [Class] The class of the deocrator.
    # @see [#class]
    alias_method :__class__, :class

    def class
      __getobj__.class
    end

    #
    # Just for curiosity - get the decorators chain
    #
    # @return [type] [description]
    def decorators_chain
      decorated = __getobj__
      chain = decorated.kind_of?(Blacksheep::ActionDecorator) ? decorated.decorators_chain : [ decorated.class ]

      chain.unshift(self.__class__)
    end

  end
end
