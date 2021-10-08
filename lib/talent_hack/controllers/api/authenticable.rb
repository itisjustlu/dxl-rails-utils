# frozen_string_literal: true

require 'active_support/concern'

module TalentHack
  module Controllers
    module Api
      module Authenticable
        extend ActiveSupport::Concern

        included do
          alias_method :authenticate_talent!, :authenticate_user!
        end

        def authenticate_user
          load_current_user!
        rescue JWT::DecodeError
          invalid_authentication
        end

        # Validates the token and user and sets the @current_user scope
        def authenticate_user!
          authenticate_user
          invalid_authentication unless @current_user
        end

        # Returns 401 response. To handle malformed / invalid requests.
        def invalid_authentication
          render json: {error: 'Invalid Request'}, status: 401
        end

        private

        def secret_key
          Rails.application.secrets.jwt_secret
        end

        # Deconstructs the Authorization header and decodes the JWT token.
        def payload
          auth_header = request.headers['X-Th-Authorization']
          token = auth_header.split(' ').last
          JWT.decode(token, secret_key, true, { algorithm: 'HS256' })
        rescue
          nil
        end

        # Sets the @current_user with the user_id from payload
        def load_current_user!
          return unless payload.present?
          @current_user ||= User.find_by(id: payload[0]['user_id'])
        end

        def current_user
          @current_user
        end

        def current_talent
          @current_user.talent
        end
      end
    end
  end
end
