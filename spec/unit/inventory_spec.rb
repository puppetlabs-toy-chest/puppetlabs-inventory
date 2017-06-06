require 'spec_helper'
require 'puppet_x/puppetlabs/inventory'

describe PuppetX::Puppetlabs::Inventory do
  before(:all) do
    @inventory = described_class.new
    @data = @inventory.generate
  end

  it 'sets up Puppet' do
    expect(Puppet).to receive(:initialize_facts).and_call_original
    expect(Puppet::Type).to receive(:loadall).and_call_original
    described_class.new
  end

  context '#catalog' do
    it 'returns a Catalog object' do
      expect(@inventory.catalog).to be_a(Puppet::Resource::Catalog)
    end
  end

  context '#generate' do
    it 'returns an array of resources' do
      expect(@data).to be_a(Array)
    end

    %w[package service user group].each do |resource_name|
      it "collects #{resource_name} resources" do
        expect(@data.count { |resource| resource[:resource] == resource_name }).to be > 0
      end
    end
  end
end
