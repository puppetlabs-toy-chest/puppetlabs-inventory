require 'spec_helper'
require 'puppet_x/puppetlabs/inventory'

describe PuppetX::Puppetlabs::Inventory do
  before(:all) do
    @inventory = PuppetX::Puppetlabs::Inventory.new
    @data = @inventory.generate
  end

  it 'should setup Puppet' do
    expect(Puppet).to receive(:initialize_facts).and_call_original
    expect(Puppet::Type).to receive(:loadall).and_call_original
    PuppetX::Puppetlabs::Inventory.new
  end

  context '#catalog' do
    it 'should return a Catalog object' do
      expect(@inventory.catalog).to be_a(Puppet::Resource::Catalog)
    end
  end

  context '#generate' do
    it 'should return an array of resources' do
      expect(@data).to be_a(Array)
    end

    ['package', 'service', 'user', 'group'].each do |resource_name|
      it "should have collected some #{resource_name}" do
        expect(@data.count { |resource| resource[:resource] == resource_name }).to be > 0
      end
    end
  end
end
