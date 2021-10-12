# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::TalentHack::Structs::ApplicationStruct do
  class DummyStruct < TalentHack::Structs::ApplicationStruct
    attribute :test, ::TalentHack::Structs::Types::String
  end

  describe '.initialize' do
    subject { DummyStruct.new(test: 'something') }

    it 'should set variables properly' do
      expect(subject.test).to eq('something')
    end
  end
end