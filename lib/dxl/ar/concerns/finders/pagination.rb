# frozen_string_literal: true

module DXL
  module AR
    module Concerns
      module Finders
        module Pagination
          DEFAULT = {
            page: 1,
            per: 20,
          }.freeze

          def page
            (context.opts[:page] || DEFAULT[:page]).to_i
          end

          def per
            (context.opts[:per] || DEFAULT[:per]).to_i
          end
          alias_method :limit, :per

          def offset
            (page - 1) * per
          end

          def apply_pagination
            context.relation = context.relation.offset(offset).limit(limit)
          end
        end
      end
    end
  end
end
