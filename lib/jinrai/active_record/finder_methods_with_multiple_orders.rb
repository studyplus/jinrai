require 'jinrai/active_record/cursor_methods'

module Jinrai
  module ActiveRecord #:nodoc:
    module FinderMethodsWithMultipleOrders
      extend ActiveSupport::Concern

      module ClassMethods
        private

        def after_with_multiple_orders(cursor, options)
          relation, multiple_orders = pre_proc(options)
          relation = cursoring_with_multiple_orders(relation, cursor, multiple_orders)
          relation.order(multiple_orders).extending_cursor
        end

        def before_with_multiple_orders(cursor, options)
          relation, multiple_orders = pre_proc(options)
          relation = cursoring_with_multiple_orders(relation, cursor, multiple_orders, reverse: true)
          relation.order(multiple_orders).extending_cursor
        end

        def cursor_with_multiple_orders(options)
          relation, multiple_orders = pre_proc(options)

          relation = cursoring_with_multiple_orders(relation, options[:since], multiple_orders)
          relation = cursoring_with_multiple_orders(relation, options[:till], multiple_orders, reverse: true)

          relation.order(multiple_orders).extending_cursor
        end

        def cursoring_with_multiple_orders(relation, cursor, multiple_orders, reverse: false)
          return relation unless cursor

          rank_by_sort_key = to_rank_by_sort_key(multiple_orders, reverse: reverse)

          attributes = default_attributes_from_cursor.call(decode_cursor(cursor))
          pointed = find_by!(attributes)

          exprs = []
          last_eq_expr = nil
          rank_by_sort_key.each do |sort_key, rank|
            if last_eq_expr.nil?
              exprs << arel_table[sort_key].send(rank, pointed[sort_key])
              last_eq_expr = arel_table[sort_key].eq(pointed[sort_key])
            else
              exprs << arel_table.grouping(
                last_eq_expr.and(
                  arel_table[sort_key].send(rank, pointed[sort_key])
                )
              )
              last_eq_expr = last_eq_expr.and(arel_table[sort_key].eq(pointed[sort_key]))
            end
          end

          relation.where(
            exprs.inject(::Arel::Nodes::False.new) { |c, e| c.or(e) } # connect with OR
          )
        rescue ::ActiveRecord::StatementInvalid => e
          # TODO: modify error message
          raise Jinrai::ActiveRecord::StatementInvalid, e
        rescue ::ActiveRecord::RecordNotFound
          raise Jinrai::ActiveRecord::RecordNotFound,
            "Could not find record cursor pointing, Check cursor_format settings."
        end

        def pre_proc(options)
          raise ArgumentError, "order option is required" unless options[:order].present?
          raise ArgumentError, "order option and sort_at option cannot be not used together" if options[:sort_at].present?

          relation = all

          raise "Cannot use order method before cursor/after/before methods" if relation.order_values.present?

          multiple_orders = options[:order]
          unless multiple_orders.has_key?(primary_key.to_sym)
            multiple_orders = multiple_orders.merge(id: :asc)
          end

          return relation, multiple_orders
        end

        def to_rank_by_sort_key(multiple_orders, reverse: false)
          multiple_orders.map do |sort_key, sort_order|
            case sort_order
            when :desc
              [sort_key, (reverse ? :gt : :lt)]
            when :asc
              [sort_key, (reverse ? :lt : :gt)]
            else
              raise ArgumentError, "sort_order must be :desc or :asc"
            end
          end.to_h
        end
      end
    end
  end
end
