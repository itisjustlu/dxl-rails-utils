# frozen_string_literal: true

require 'spec_helper'
require 'active_model'

RSpec.describe ::TalentHack::Services::Validator do
  class DummyValidator
    include ::ActiveModel::Model

    attr_accessor :name

    validates :name, presence: true
  end

  subject { described_class.new(object, validator_klass: DummyValidator).call }
  let(:object) { double(save: nil, attributes: attributes, errors: errors) }
  let(:attributes) { { name: 'Test' } }
  let(:errors) { double(add: nil) }

  describe '.call' do
    it 'should call object save' do
      expect(object).to receive(:save)
      subject
    end

    it 'should not call errors add' do
      expect(errors).to_not receive(:save)
      subject
    end

    context 'when having errors' do
      let(:attributes) { { name: nil } }
      it 'should not save' do
        expect(object).to_not receive(:save)
        subject
      end

      it 'should call errors add' do
        expect(errors).to receive(:add)
        subject
      end
    end
  end
end
