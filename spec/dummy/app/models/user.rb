class User < ApplicationRecord
  cursor_format :id, :name, :age, :created_at
end
