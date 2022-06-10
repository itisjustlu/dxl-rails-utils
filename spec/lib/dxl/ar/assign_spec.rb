# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::DXL::AR::Assign do
  subject { described_class.call(opts: { title: 'Test' }, key: :question, object_class: Question) }

  describe '.call' do
    it 'assigns object' do
      expect(subject.question).to be_a(Question)
    end
  end
end
