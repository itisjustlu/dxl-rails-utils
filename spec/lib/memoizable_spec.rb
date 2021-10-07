# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::TalentHack::Memoizable do
  class DummyMemoizableClass
    include ::TalentHack::Memoizable

    def call(str)
      memoize { str }
    end

    def call2(str)
      memoize { str }
    end

  end

  subject { DummyMemoizableClass.new }

  describe '.call' do
    it 'should always return same value' do
      expect(subject.call('Lu')).to eq('Lu')
      expect(subject.call('Juarez')).to eq('Lu')
    end

    it 'should check for nils' do
      expect(subject.call(nil)).to be_falsey
      expect(subject.call('Lu')).to be_falsey
    end

    it 'should check for falsys' do
      expect(subject.call(false)).to be_falsey
      expect(subject.call('Lu')).to be_falsey
    end

    context 'when having multiple methods memoizing' do
      it 'should memoize separately' do
        expect(subject.call('Lu')).to eq('Lu')
        expect(subject.call('Juarez')).to eq('Lu')

        expect(subject.call2('Test')).to eq('Test')
        expect(subject.call2('More Test')).to eq('Test')
      end
    end
  end
end