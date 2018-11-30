require "active_model_serializers"

module ActiveModel
  class Serializer
    class CollectionSerializer
      def paginated?
        ActiveModelSerializers.config.jsonapi_pagination_links_enabled && object.try(:cursored?)
      end
    end
  end
end

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
