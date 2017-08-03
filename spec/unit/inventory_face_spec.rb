require 'spec_helper'
require 'puppet/face'

describe Puppet::Face[:inventory, '0.1.0'] do
  before(:all) do
    @inventory = PuppetX::Puppetlabs::Inventory.new
  end

  it 'has a default action of all' do
    expect(subject.get_action('all')).to be_default
  end

  it 'by default does not ignore any facts' do
    expect(subject.get_option('ignore_facts').default).to eq('')
  end

  it { subject.summary.is_a?(String) }
  %i[all facts resources catalog].each do |subcommand|
    describe "##{subcommand}" do
      it 'runs without error' do
        allow(PuppetX::Puppetlabs::Inventory).to receive(:new).and_return(@inventory)
        expect do
          subject.send(subcommand)
        end.not_to raise_error
      end

      it { is_expected.to respond_to subcommand }
      it { is_expected.to be_action subcommand }
    end
  end
end
