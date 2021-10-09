# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::TalentHack::Services::ApplicationService do
  class DummyService < ::TalentHack::Services::ApplicationService
    use
  end

  class DummyMemoizableService < ::TalentHack::Services::ApplicationService
    use :memoize
  end

  class DummyValidatableService < ::TalentHack::Services::ApplicationService
    use :validator
  end

  class DummyNoModulesService < ::TalentHack::Services::ApplicationService
    no_modules
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

  describe 'DummyNoModulesService' do
    it 'should not respond_to memoize' do
      expect(DummyNoModulesService.new.respond_to?(:memoize)).to eq(false)
    end

    it 'should not respond_to validate' do
      expect(DummyNoModulesService.new.respond_to?(:validate)).to eq(false)
    end
  end
end
