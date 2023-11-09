# frozen_string_literal: true

require 'jwt'

def json_fixture(path)
  JSON.parse(file_fixture("#{path}.json").read).deep_symbolize_keys
end

def json_body
  JSON.parse(response.body)
end

def rswag_json!(tag:)
  tags tag
  consumes 'application/json'
  produces 'application/json'
end

def lambda_request
  before do |example|
    @lambda = -> { submit_request(example.metadata) }
  end
end

def schema_builder(serializer, klass, included: nil)
  ::DXL::Schemas::Builder.new(serializer, klass, included: included).call
end

def schema_form_builder(klass)
  parameter name: :params, in: :body, schema: { type: :object, properties: klass.new.call }
end