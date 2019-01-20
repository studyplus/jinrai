class User < ApplicationRecord
  cursor_per 20

  def created_at_human
    created_at.iso8601
  end
end
