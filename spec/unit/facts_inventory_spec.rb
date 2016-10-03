require 'spec_helper'
require 'puppet_x/puppetlabs/facts_inventory'

describe PuppetX::Puppetlabs::FactsInventory do
  before(:all) { @facts = ['timezone', 'uptime_days'] }

  context 'with no arguments' do
    before(:all) do
      @inventory = PuppetX::Puppetlabs::FactsInventory.new
      @data = @inventory.generate
    end
    it 'should return a hash of facts' do
      expect(@data).to be_a(Hash)
    end
    it 'should have some default facts' do
      @facts.each do |fact|
        expect(@data.key?(fact)).to be_truthy
      end
    end
  end

  context 'with some ignored facts' do
    before(:all) do
      @inventory = PuppetX::Puppetlabs::FactsInventory.new(ignore: @facts)
      @data = @inventory.generate
    end
    it 'should return a hash of facts' do
      expect(@data).to be_a(Hash)
    end
    it 'should not have ignored facts' do
      @facts.each do |fact|
        expect(@data.key?(fact)).to be_falsy
      end
    end
  end
end
