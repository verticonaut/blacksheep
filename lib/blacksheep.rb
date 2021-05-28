require "blacksheep/version"
require "blacksheep/action_result"
require "blacksheep/action_error"
require "blacksheep/action_decorator"
require "blacksheep/decorators/error_handler"
require "blacksheep/decorators/default_error_handler"
require "blacksheep/decorators/json_transformer"
require "blacksheep/decorators/result_matcher"
require "blacksheep/decorators/localizer"
require "blacksheep/action"
require "blacksheep/version"



module Blacksheep
  class Error < StandardError; end
  # Your code goes here...
end
