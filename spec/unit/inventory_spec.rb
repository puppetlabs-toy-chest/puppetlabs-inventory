require 'spec_helper'
require 'puppet_x/puppetlabs/inventory'

describe PuppetX::Puppetlabs::Inventory do # rubocop:disable Metrics/BlockLength
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

    %w[group].each do |resource_name|
      it "collects #{resource_name} resources" do
        expect(@data.count { |resource| resource[:resource] == resource_name }).to be > 0
      end
    end

    %w[package service user].each do |resource_name|
      it "collects #{resource_name} resources" do
        skip 'Skipping as too dependent on system on which tests are run'
      end
    end
  end
end
