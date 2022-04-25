# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::DXL::Services::ApplicationService do
  class DummyService < ::DXL::Services::ApplicationService
    behave_as :memoize, :validator
  end

  class DummyMemoizableService < ::DXL::Services::ApplicationService
    behave_as :memoize
  end

  class DummyValidatableService < ::DXL::Services::ApplicationService
    behave_as :validator
  end

  describe 'DummyService' do
    it 'should respond_to memoize' do
      expect(DummyService.new.respond_to?(:memoize)).to eq(true)
    end

    it 'should respond_to validate' do
      expect(DummyService.new.respond_to?(:validate)).to eq(true)
    end
  end

  describe 'DummyMemoizableService' do
    it 'should respond_to memoize' do
      expect(DummyMemoizableService.new.respond_to?(:memoize)).to eq(true)
    end

    it 'should not respond_to validate' do
      expect(DummyMemoizableService.new.respond_to?(:validate)).to eq(false)
    end
  end

  describe 'DummyValidatableService' do
    it 'should not respond_to memoize' do
      expect(DummyValidatableService.new.respond_to?(:memoize)).to eq(false)
    end

    it 'should respond_to validate' do
      expect(DummyValidatableService.new.respond_to?(:validate)).to eq(true)
    end
  end
end
