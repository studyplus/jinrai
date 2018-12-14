# Jinrai
Jinraiはカーソルベースのページネータです。

## 使い方
```ruby
# config/initializers/jinrai.rb

Jinrai.configure do |config|
  config.default_cursor_per = 20 #=> User.cursor.count == 20
  config.default_cursor_format = :id, :name #=> cursor format will be "#{user.id}_#{user.name}"
  config.cursor_sort_order = :desc
end
```

モデルごとにリクエスト毎のレコード返却件数, カーソルのフォーマットを指定することができます。
```ruby
# app/model/user.rb

class User < ApplicationRecord
  cursor_per 100
  cursor_format :name, :age
  cursor_order :asc # default: :desc
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

`.cursor`メソッドは `till`と`since`,`sort_at`の3つの引数を持っていて, 任意の範囲のレコードを取り出したり、特定の属性で並び替えることができます.
```ruby
since_cursor = User.cursor.till_cursor
User.cursor(since: since_cursor) # since_cursor移行のレコードセットを返します

till_cursor = User.cursor.since_cursor
User.cursor(till: till_cursor) # till_cursor以前のレコードセットを返します

# sinceとtillを同時に指定することもできて、この場合since_corsor以降、till_cursor以前の範囲に含まれるレコードの最新cursor_per件を返します.
User.cursor(since: since_cursor, till: till_cursor)
```

カーソルはコレクションに対して`#since_cursor`, `#till_cursor`を呼び出すか、modelのインスタンスに対して`#to_cursor`を呼び出すことで取得できます。
```ruby
users = User.cursor
users.since_cursor # コレクションの最初のレコードを指し示すカーソルを返します
users.till_cursor # コレクションの最後のレコードを指し示すカーソルを返します
```
