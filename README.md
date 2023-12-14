# Jinrai

Jinrai is a awesome cursor based paginator

## Usage

```ruby
# config/initializers/jinrai.rb

Jinrai.configure do |config|
  config.default_cursor_per = 20 #=> User.cursor.count == 20
  config.default_cursor_format = :id, :name #=> cursor format will be "#{user.id}_#{user.name}"
  config.default_cursor_sort_order = :desc
end
```

```ruby
# app/model/user.rb

class User < ApplicationRecord
  cursor_per 100
  cursor_format :name, :age
  cursor_sort_order :asc # default: :desc
end

User.cursor.count #=> 100
User.cursor.since_format #=> generate cursor fomatted "#{user.name}_#{user.age}"
```

```ruby
User.cursor #=> get latest 20 records.
User.cursor.count #=> 20
```

`.cursor` has two arguments, `till` and `since`, and by passing them we can get record collection of arbitrary interval.

```ruby
since_cursor = User.cursor.till_cursor
User.cursor(since: since_cursor) # return records older than the record pointed by the cursor

till_cursor = User.cursor.since_cursor
User.cursor(till: till_cursor) # return records newer than the record pointed by the cursor

User.cursor(since: since_cursor, till: till_cursor) # return records newer than the record pointed by the since cursor and older than the record pointed by the till cursor.
```

Get cursor by calling `since_cursor` or `till_cursor`.

```ruby
users = User.cursor
users.since_cursor # this cursor points first record of User collection
users.till_cursor # this cursor points last record of User collection
```

`.cursor` allows to specify order with `order` argument.
(`sort_at` is an old argument, please use `order`.)

```ruby
User.cursor(order: { age: :desc, name: :asc })
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

1. Create database

```
$ mysql --host 127.0.0.1  -uroot -e "create database jinrai_test"
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
bundle exec rspec
```

1. write a good commit message, push to your fork, then submit PullRequest.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
