# Jinrai
Jinrai is a awesome cursor type paginator

## Usage
```ruby
# config/initializers/jinrai.rb

Jinrai.configure do |config|
  config.default_cursor_per = 20 #=> User.cursor.count == 20
  config.default_cursor_format = :id, :name #=> cursor format will be "#{user.id}_#{user.name}"
  config.cursor_sort_order = :desc
end
```

```ruby
# app/model/user.rb

class User < ApplicationRecord
  cursor_per 100
  cursor_format :name, :age
  cursor_order :asc # default: :desc
end

User.cursor.count #=> 100
User.cursor.since_format #=> generate cursor fomatted "#{user.name}_#{user.age}"
```

By default, You can get 20 records collection which start with latest record; which have largest id.
```ruby
User.count #=> 40
User.cursor #=> [#<User:0x00007fa55d7a7c40
#   id: 40,
#   name: "user040",
#   age: nil,
#   created_at: Tue, 11 Dec 2018 12:29:35 UTC +00:00,
#   updated_at: Tue, 11 Dec 2018 12:29:35 UTC +00:00>,
#  #<User:0x00007fa55d7a7b00
#   id: 39,
#   name: "user039",
User.cursor.count #=> 20
```

`.cursor` has two arguments, `till` and `since`, and by passing them we can get record collection of arbitrary interval.
```ruby
since_cursor = User.cursor.till_cursor
User.cursor(since: since_cursor)
#=> [#<User:0x00007fa55dcb90f8
#   id: 20,
#   name: "user020",
#   age: nil,
#   created_at: Tue, 11 Dec 2018 12:29:35 UTC +00:00,
#   updated_at: Tue, 11 Dec 2018 12:29:35 UTC +00:00>,
#  #<User:0x00007fa55dcb8fb8
#   id: 19,
#   name: "user019",

till_cursor = User.cursor(since: since_cursor).since_cursor
User.cursor(till: till_cursor)
# =>
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'jinrai'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install jinrai
```

## Contributing
1. Fork then clone this repo:
```bash
git clone git@github.com:YOUR_USERNAME/jinrai.git
```

1. setup dependencies via bundler:
```bash
bundle install
```

1. Make sure the spec pass:
```bash
bundle exec rspec
```

1. Make your change, and write spec, make sure test pass:
```bash
bandle exec rspec
```

1. write a good commit message, push to your fork, then submit PullRequest.


## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
