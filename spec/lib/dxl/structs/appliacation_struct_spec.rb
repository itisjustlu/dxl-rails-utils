# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::DXL::Structs::ApplicationStruct do
  class DummyStruct < DXL::Structs::ApplicationStruct
    attribute :test, ::DXL::Structs::Types::String
  end

  describe '.initialize' do
    subject { DummyStruct.new(test: 'something') }

    it 'should set variables properly' do
      expect(subject.test).to eq('something')
    end
  end
end