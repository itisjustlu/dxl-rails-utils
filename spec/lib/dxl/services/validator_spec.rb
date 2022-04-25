# frozen_string_literal: true

require 'spec_helper'
require 'active_model'

RSpec.describe ::DXL::Services::Validator do
  class DummyValidator
    include ::ActiveModel::Model

    attr_accessor :name

    validates :name, presence: true
  end

  subject { described_class.new(object, validator_class: DummyValidator, error_class: DXL::Errors::ApplicationError).call }
  let(:object) { double(save: nil, attributes: attributes, errors: errors) }
  let(:attributes) { { name: 'Test' } }
  let(:errors) { double(add: nil) }

  describe '.call' do
    it 'should not raise an error' do
      expect { subject }.to_not raise_error(DXL::Errors::ApplicationError)
    end

    context 'when having errors' do
      let(:attributes) { { name: nil } }
      it 'should not raise an error' do
        expect { subject }.to raise_error(DXL::Errors::ApplicationError) { |error|
          expect(error.message).to eq(["Name can't be blank"])
        }
      end
    end
  end
end
