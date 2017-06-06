require 'spec_helper'
require 'puppet_x/puppetlabs/facts_inventory'

describe PuppetX::Puppetlabs::FactsInventory do # rubocop:disable Metrics/BlockLength
  before(:all) { @facts = %w[timezone uptime_days] }

  context 'with no arguments' do
    before(:all) do
      @inventory = described_class.new
      @data = @inventory.generate
    end
    it 'returns a hash of facts' do
      expect(@data).to be_a(Hash)
    end
    it 'has some default facts' do
      @facts.each do |fact|
        expect(@data.key?(fact)).to be_truthy
      end
    end
  end

  context 'with some ignored facts' do
    before(:all) do
      @inventory = described_class.new(ignore: @facts)
      @data = @inventory.generate
    end
    it 'returns a hash of facts' do
      expect(@data).to be_a(Hash)
    end
    it 'does not have ignored facts' do
      @facts.each do |fact|
        expect(@data.key?(fact)).to be_falsy
      end
    end
  end
end
