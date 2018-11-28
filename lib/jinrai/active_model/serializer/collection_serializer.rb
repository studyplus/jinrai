module ActiveModel
  class Serializer
    class CollectionSerializer
      def paginated?
        ActiveModelSerializers.config.jsonapi_pagination_links_enabled && object.try(:cursored?)
      end
    end
  end
end
