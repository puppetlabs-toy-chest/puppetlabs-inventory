require 'spec_helper'
require 'puppet/face'

describe Puppet::Face[:inventory, '0.1.0'] do
  it { subject.summary.is_a?(String) }
  [:all, :facts, :resources].each do |subcommand|
    describe "##{subcommand}" do
      it 'should run without error' do
        expect do
          subject.send(subcommand)
        end.to_not raise_error
      end

      it { is_expected.to respond_to subcommand }
      it { is_expected.to be_action subcommand }
    end
  end
end
