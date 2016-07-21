require 'puppet/face'
require 'facter'
require 'puppet_x/puppetlabs/inventory'

Puppet::Face.define(:inventory, '0.1.0') do
  summary 'Use Puppet as a way to inventory systems'
  action(:resources) do
    summary 'Discover resources (including packages, services, users and groups)'
    when_invoked do |*_args|
      inventory = PuppetX::Puppetlabs::Inventory.new
      inventory.generate
    end
    when_rendering :console do |return_value|
      JSON.pretty_generate(return_value)
    end
  end

  action(:all) do
    default
    summary 'Discover resources (including packages, services, users and groups) along with facts about the system'
    when_invoked do |*_args|
      inventory = PuppetX::Puppetlabs::Inventory.new
      {
        schema_version: 1,
        created: Time.now.utc.iso8601,
        resources: inventory.generate,
        facts: Facter.to_hash
      }
    end
    when_rendering :console do |return_value|
      JSON.pretty_generate(return_value)
    end
  end

  action(:facts) do
    summary 'Discover facts about the system'
    when_invoked do |*_args|
      Facter.to_hash
    end
    when_rendering :console do |return_value|
      JSON.pretty_generate(return_value)
    end
  end
end
