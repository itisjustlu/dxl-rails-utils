# frozen_string_literal: true

module DXL
  module AR
    module Concerns
      module Finders
        module Order
          DEFAULT = {
            order: :id,
            direction: :desc,
          }.freeze

          def order
            context.opts[:order] || DEFAULT[:order]
          end

          def direction
            context.opts[:direction] || DEFAULT[:direction]
          end

          def apply_order
            context.relation = context.relation.order(order => direction)
          end
        end
      end
    end
  end
end
