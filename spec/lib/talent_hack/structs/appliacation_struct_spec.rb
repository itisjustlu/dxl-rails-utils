# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::TalentHack::Structs::ApplicationStruct do
  class DummyStruct < Struct.new(:test)
    include ::TalentHack::Structs::ApplicationStruct
  end

  describe '.initialize' do
    subject { DummyStruct.new(test: 'something') }

    it 'should set variables properly' do
      expect(subject.test).to eq('something')
    end
  end
end