module ActiveModelSerializers
  module Adapter
    class JsonApi < Base
      class PaginationCursors < PaginationLinks
        def as_json
          {
            since: collection.since_cursor,
            till: collection.till_cursor
          }
        end
      end
    end
  end
end
