# Jinrai

Jinrai はカーソルベースのページネータです。

## 使い方

```ruby
# config/initializers/jinrai.rb

Jinrai.configure do |config|
  config.default_cursor_per = 20 #=> User.cursor.count == 20
  config.default_cursor_format = [:id, :name] #=> cursor format will be "#{user.id}_#{user.name}"
  config.default_cursor_sort_at = :id
  config.default_cursor_sort_order = :desc
end
```

モデルごとにリクエスト毎のレコード返却件数, カーソルのフォーマットを指定することができます。

```ruby
# app/model/user.rb

class User < ApplicationRecord
  cursor_per 100
  cursor_format [:name, :age]
  cursor_sort_at = :created_at # default: :id
  cursor_sort_order :asc # default: :desc
end

User.cursor.count #=> 100
User.cursor.since_cursor # #{user.name}_#{user.age}のフォーマットのカーソルを生成します。
```

```ruby
User.cursor # 最新のレコードをcursor_perの数だけ返却します。
User.cursor.count #=> 20

User.after(cursor) # カーソルが指し示すレコード以降のデータを返します
User.before(cursor) # カーソルが指し示すレコード以前のデータを返します
```

`.cursor`メソッドは `till`と`since`,`sort_at`の 3 つの引数を持っていて, 任意の範囲のレコードを取り出したり、特定の属性で並び替えることができます.

```ruby
next_cursor = User.cursor.next_cursor
User.cursor(since: next_cursor) # next_cursor以降のレコードセットを返します

prev_cursor = User.cursor.prev_cursor
User.cursor(till: prev_cursor) # prev_cursor以前のレコードセットを返します

# sinceとtillを同時に指定することもできて、この場合since_corsor以降、prev_cursor以前の範囲に含まれるレコードの最新cursor_per件を返します.
User.cursor(since: next_cursor, till: prev_cursor)
```

カーソルはコレクションに対して`#next_cursor`, `#prev_cursor`を呼び出すか、model のインスタンスに対して`#to_cursor`を呼び出すことで取得できます。

```ruby
users = User.cursor
users.next_cursor # コレクションの最後のレコードを指し示すカーソルを返します
users.prev_cursor # コレクションの最初のレコードを指し示すカーソルを返します
```
