# Blacksheep

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/blacksheep`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'blacksheep'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install blacksheep

## Usage

### Actions

Core of blacksheep is the `Blacksheep::Action`. It provides basic functionality to handle rest API actions - but can handle other actions as well. The core methods of actions are:

  * #perform with a block that implements the action
  * #call on an action instance for processing and a potential block for result matching (see dcorators below).

`#perform` takes a block that is executed with the params passed. #perform has the following api:
  `#perform(params, current_user: (default to nil), **options)`

`#call` can be used when a Blacksheep::Action is sublassed as an action processing its opertation in a call method with the same signature of `#perform`. When using the `ResultMatcher` decorator a block can be used for result matching.


```ruby
##perform sample
action_result = Blacksheep::Action.new.perform(params) do |params|
  # do somethin with the params that return a `Blacksheep::ActionResult`
end

##perform sample
action_result = MyAction.new.call(params, current_user: current_user)
```

`Blacksheeep::ActionResult` has a data and a status attribute. In case of json api actions its expected to store a json response into the data attribute, and the respective http status into the status attribute.


### Decorators

This alone does not give any benefit. Modifying the action with decorators adds additional functionality:

  * `JsonTransformer`
  * `Localizer`
  * `DefaultErrorHandler`
  * `ResultMatcher`

The decaorators can be configured globally by defining them in an initializer.

```ruby
# Defining decorator wheras innermost is first
Blacksheep::Action.add_decorator(Blacksheep::Decorators::Localizer)
Blacksheep::Action.add_decorator(Blacksheep::Decorators::DefaultErrorHandler)
Blacksheep::Action.add_decorator(Blacksheep::Decorators::JsonTransformer)
Blacksheep::Action.add_decorator(Blacksheep::Decorators::ResultMatcher)
```

#### Blacksheep::Decorators::Localizer

A localizer sets the I18n locale when passed in a request parameter named `_locale`.


#### Blacksheep::Decorators::DefaultErrorHandler

A default error handler can be used in API opertions. The handler catches an error and returns an ActionResult such as…

```ruby
def handle_exception(exception)
  json = {
    errors: [
      pointer: {
        source: 'Internal'
      },
      title: "#{exception.class}",
      detail: "#{exception.message}",
    ]
  }
  status = :internal_server_error # 500

  ActionResult.new(json, status)
end
```

You can write your own ErrorHandler by including the module `Blacksheep::Decorators::ErrorHandler` and implementing the method `#handle_exception(<Exception>)`.


#### Blacksheep::Decorators::JsonTransformer

Assuming the params is a json payload with a specific caseing (e.g. camelCase when used in a JS application such as Vue) the JsonTransfomer takes the params and transforms it's keys into snake_case as used in ruby often.
The request has to define the case passed (and hence desired response casing) in the parameter `_case`. If the case is requests as `camel` then parameter keys are transformed to `snake_case` before beeing passed into the action and are transformed back into CamelCase when leaving the operation.

If JsonTransfomer is used the action should return a simple JSON structure which is transfformed and stored in an ActionResult.


#### Blacksheep::Decorators::ResultMatcher

This decorator can be used when implementing your own actions by subclassing `Blacksheep::Action` and using the  `#call` style for processing. Adding the `ResultMatcher` decorator enables to write a matcher block such as…

```ruby
MyAction.new.call(params) do |m|
  m.success do |action_result|
    # do something in success case
  end
  m.failure :unauthorized do |action_result|
    # special handling for unauthorized access
  end
  m.failure do |v|
    # any other failure
  end
end
```

The action has to return a Blacksheep::ActionResult which is checked for status `:ok` for success case and any other status in failure case.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

```
gem build blacksheep
gem push blacksheep-0.x.y.gem
``

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/verticonaut/blacksheep.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
