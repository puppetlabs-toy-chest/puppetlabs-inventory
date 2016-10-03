require 'puppet/face'
require 'puppet_x/puppetlabs/inventory'
require 'puppet_x/puppetlabs/facts_inventory'

Puppet::Face.define(:inventory, '0.1.0') do
  summary 'Use Puppet as a way to inventory systems'
  option '--ignore-facts STRING' do
    summary 'A comma separated list of top level facts to ignore'
    default_to { '' }
  end

  action(:resources) do
    summary 'Discover resources (including packages, services, users and groups)'
    when_invoked do |*options|
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
    when_invoked do |*options|
      args = options.pop
      inventory = PuppetX::Puppetlabs::Inventory.new
      facts = PuppetX::Puppetlabs::FactsInventory.new(ignore: args[:ignore_facts].split(','))
      {
        schema_version: 1,
        created: Time.now.utc.iso8601,
        resources: inventory.generate,
        facts: facts.generate
      }
    end
    when_rendering :console do |return_value|
      JSON.pretty_generate(return_value)
    end
  end

  action(:facts) do
    summary 'Discover facts about the system'
    when_invoked do |*options|
      args = options.pop
      facts = PuppetX::Puppetlabs::FactsInventory.new(ignore: args[:ignore_facts].split(','))
      facts.generate
    end
    when_rendering :console do |return_value|
      JSON.pretty_generate(return_value)
    end
  end

  action(:catalog) do
    summary 'Generate a Puppet catalog for the system'
    when_invoked do |*options|
      inventory = PuppetX::Puppetlabs::Inventory.new
      inventory.catalog.to_data_hash
    end
    when_rendering :console do |return_value|
      JSON.pretty_generate(return_value)
    end
  end

  action(:report) do
    summary 'Generate a Puppet report for the system'
    when_invoked do |*options|
      inventory = PuppetX::Puppetlabs::Inventory.new(with_resources: false)
      report = Puppet::Transaction::Report.new('inventory')
      inventory.catalog.apply(report: report)
      report.finalize_report
      report.to_data_hash
    end
    when_rendering :console do |return_value|
      JSON.pretty_generate(return_value)
    end
  end
end
