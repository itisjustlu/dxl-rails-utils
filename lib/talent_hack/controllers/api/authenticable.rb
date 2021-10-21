# frozen_string_literal: true

require 'active_support/concern'
require 'jwt'

module TalentHack
  module Controllers
    module Api
      module Authenticable
        extend ActiveSupport::Concern

        def authenticate_lazy_user!
          authenticate_lazy_user
          invalid_authentication unless current_user_uuid
        end

        def authenticate_lazy_user
          with_jwt_rescue { load_user_uuid! }
        end

        def authenticate_lazy_talent!
          authenticate_lazy_talent
          invalid_authentication unless current_talent_uuid
        end

        def authenticate_lazy_talent
          with_jwt_rescue { load_talent_uuid! }
        end

        private

        def with_jwt_rescue
          yield
        rescue JWT::DecodeError
          invalid_authentication
        end

        def invalid_authentication
          render json: {error: 'Invalid Request'}, status: 401
        end

        def secret_key
          ENV.fetch('JWT_SECRET', 'theth')
        end

        def payload
          auth_header = request.headers['X-Th-Authorization']
          token = auth_header.split(' ').last
          JWT.decode(token, secret_key, true, { algorithm: 'HS256' })
        rescue
          nil
        end

        def load_user_uuid!
          return unless payload.present?
          @current_user_uuid = payload[0]['user_uuid']
        end

        def load_talent_uuid!
          return unless payload.present?
          @current_talent_uuid = payload[0]['talent_uuid']
        end

        def current_user_uuid
          @current_user_uuid
        end

        def current_talent_uuid
          @current_talent_uuid
        end
      end
    end
  end
end
