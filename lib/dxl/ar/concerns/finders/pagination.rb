# frozen_string_literal: true

require 'dxl/ar/configuration'

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
            (context.opts[:per] || default_per_page).to_i
          end
          alias_method :limit, :per

          def default_per_page
            DXL::AR::Configuration.configuration.per_page || DEFAULT[:per]
          end

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
