module Jinrai::ActiveRecord
  module Cursor
    def cursor(since: nil, till: nil, sort_at: primary_key)
      cursoring(:gt, since, sort_at).cursoring(:lt, till, sort_at).order(sort_at).per_cursor
    end

    def after(cursor = nil, sort_at: primary_key)
      cursoring(:gt, cursor, sort_at).order(sort_at).per_cursor
    end

    def before(cursor, sort_at: primary_key)
      cursoring(:lt, cursor, sort_at).order(sort_at).per_cursor
    end

    def per_cursor(num)
      num ||= Jinrai.config.default_per_cursor
      if (n = num.to_i) < 0 || !(/^\d/ =~ num.to_s)
        self
      else
        limit(n)
      end
    end

    private

    def cursoring(rank, cursor, sort_at)
      return all unless cursor
      cursor_value, cursor_id = decode_cursor(cursor)

      condition_1 = arel_table[sort_at].send(rank, cursor_value)
      condition_2 = arel_table.grouping(arel_table[sort_at].eq(cursor_value)
        .and(arel_table[primary_key].send(rank, decode_id(cursor_id))))

      relation.is_cursored = true
      relation.sort_at = sort_key
      where(condition_1.or(condition_2))
    end

    # とりあえず2つの値
    def decode_cursor(cursor)
      Base64.decode64(cursor).split("_")
    end
  end

  ::ActiveRecord::Relation.send(:include, Cursor)
end
