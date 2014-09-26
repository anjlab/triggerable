# Triggerable

[![Code Climate](https://codeclimate.com/github/anjlab/triggerable/badges/gpa.svg)](https://codeclimate.com/github/anjlab/triggerable)

Triggerable is a powerful engine for adding a conditional behaviour for ActiveRecord models. This logic can be defined in two ways - as triggers and automations. Triggers are called right after model creating, updating or saving, and automations are run on schedule (e.g. 2 hours after update).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'triggerable'
```

And then execute:

```shell
bundle
```

## Usage

Setup and defining trigger and automation:

```ruby
class User < ActiveRecord::Base
  trigger on: :after_create, if: {receives_sms: true}, do |user|
    user.send_welcome_sms
  end

  automation if: {created_at: {after: 24}, confirmed: false} do |user|
    user.send_confirmation_email
  end
end
```

Combining different conditions and predicates:

```ruby
trigger on: :after_create, if: {field: {is: 1}}, ...
# short form
trigger on: :after_create, if: {field: 1}, ...

trigger on: :after_create, if: {field: {is_not: 1}}, ...

trigger on: :after_create, if: {field: {in: [1, 2, 3]}}, ...
# short form
trigger on: :after_create, if: {field: [1, 2, 3]}, ...

trigger on: :after_create, if: {field: {greater_then: 1}}, ...
trigger on: :after_create, if: {field: {less_then: 1}}, ...

trigger on: :after_create, if: {field: {exists: true}}, ...

trigger on: :after_create, if: {and: [{field1: '1'}, {field2: 1}]}, ...
trigger on: :after_create, if: {or: [{field1: '1'}, {field2: 1}]}, ...
```

Triggerable does not run automations by itself, you should call `Engine.run_automations(interval)` using any scheduling script. Interval is a time difference between calling the method (e.g. `1.hour`). *You should avoid situations when your interval is less then the time your automations need to complete!*

If you have more complex condition or need to check associations (not supported in DSL now), you should use a lambda condition form:

```ruby
trigger on: :after_update, if: -> (user) { user.orders.any? } do
  # ...
end
```

If you need to share logic between triggers/automations bodies you can move it into separate class. It should be inherited from `Triggerable::Action` and implement a single method `run_for!(obj)` where obj is a triggered object. Then you can pass a name of your action class instead of do block.

```ruby
class SendWelcomeSms < Triggerable::Action
  def run_for! object
    SmsGateway.send_to object.phone, welcome_text
  end
end

class User
  trigger on: :after_create, if: {receives_sms: true}, do: :send_welcome_sms
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
