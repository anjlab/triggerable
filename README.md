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
  include Triggerable

  trigger on: :create, if: {receives_sms: true}, do |user|
    user.send_welcome_sms
  end

  automation if: {confirmed: false}, after: {create: 24} do |user|
    user.send_confirmation_email
  end
end
```

Combining different conditions and predicates:

```ruby
trigger on: :create, if: {field: {is: 1}}, ...
# short form
trigger on: :create, if: {field: 1}, ...

trigger on: :create, if: {field: {is_not: 1}}, ...

trigger on: :create, if: {field: {in: [1, 2, 3]}}, ...
# short form
trigger on: :create, if: {field: [1, 2, 3]}, ...

trigger on: :create, if: {field: {greater_then: 1}}, ...
trigger on: :create, if: {field: {less_then: 1}}, ...

trigger on: :create, if: {field: {exists: true}}, ...

trigger on: :create, if: {and: [{field1: '1'}, {field2: 1}]}, ...
trigger on: :create, if: {or: [{field1: '1'}, {field2: 1}]}, ...
```

If you have more complex condition or need to check associations (not supported in DSL now), you should use a lambda condition form:

```ruby
trigger on: :update, if: -> (user) { user.orders.any? } do
  # ...
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
