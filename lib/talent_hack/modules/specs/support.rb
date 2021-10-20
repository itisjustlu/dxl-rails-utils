# frozen_string_literal: true

require 'jwt'

module TalentHack
  module Modules
    module Specs
      module Support
        def json_fixture(path)
          JSON.parse(file_fixture("#{path}.json").read).deep_symbolize_keys
        end

        def json_body
          JSON.parse(response.body)
        end

        def jwt_token(user)
          JWT.encode(
            { user_id: user.id },
            ENV.fetch('JWT_SECRET', 'theth'),
            'HS256'
          )
        end

        def rswag_json!(tag:)
          tags tag
          consumes 'application/json'
          produces 'application/json'
        end

        def rswag_authenticate_user!
          parameter name: 'X-Th-Authorization', :in => :header, :type => :string
          let!(:'X-Th-Authorization') { "Bearer #{jwt_token(user)}" }
        end

        def lambda_request
          before do |example|
            @lambda = -> { submit_request(example.metadata) }
          end
        end
      end
    end
  end
end
