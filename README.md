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
