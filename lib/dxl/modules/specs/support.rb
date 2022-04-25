# frozen_string_literal: true

require 'jwt'

def json_fixture(path)
  JSON.parse(file_fixture("#{path}.json").read).deep_symbolize_keys
end

def json_body
  JSON.parse(response.body)
end

def jwt_token_talent(talent)
  JWT.encode(
    { talent_uuid: talent.uuid },
    ENV.fetch('JWT_SECRET', 'theth'),
    'HS256'
  )
end

def jwt_token_user(user)
  JWT.encode(
    { user_uuid: user.uuid },
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
  let!(:'X-Th-Authorization') { "Bearer #{jwt_token_user(user)}" }
end

def rswag_authenticate_talent!
  parameter name: 'X-Th-Authorization', :in => :header, :type => :string
  let!(:'X-Th-Authorization') { "Bearer #{jwt_token_talent(talent)}" }
end

def lambda_request
  before do |example|
    @lambda = -> { submit_request(example.metadata) }
  end
end

def schema_builder(serializer, klass, relationships: nil)
  ::DXL::Schemas::Builder.new(serializer, klass, relationships: relationships).call
end

def schema_form_builder(klass)
  parameter name: :params, in: :body, schema: { type: :object, properties: klass.new.call }
end