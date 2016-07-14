require 'puppet/face'
require 'facter'

REQUIRED_TYPES = [:group, :package, :service, :user].freeze

def format_resources(array) # rubocop:disable Metrics/AbcSize
  array.collect do |hash|
    case hash.type
    when 'Package'
      {
        title: hash.title.to_s,
        resource: hash.type.downcase,
        provider: hash[:provider],
        versions: Array(hash[:ensure]).map { |v| v.to_s }
      }
    when 'User'
      {
        title: hash.title.to_s,
        resource: hash.type.downcase,
        uid: hash[:uid],
        gid: hash[:gid],
        groups: hash[:groups],
        home: hash[:home],
        shell: hash[:shell],
        comment: hash[:comment]
      }
    when 'Group'
      {
        title: hash.title.to_s,
        resource: hash.type.downcase,
        gid: hash[:gid]
      }
    when 'Service'
      {
        title: hash.title.to_s,
        resource: hash.type.downcase,
        ensure: hash[:ensure],
        enable: hash[:enable],
        provider: hash[:provider]
      }
    end
  end
end

def inventory_resources
  Puppet::Type.loadall
  catalog = Puppet::Resource::Catalog.new
  Puppet::Type.eachtype do |type_class|
    type_class.instances.each do |i|
      catalog.add_resource(i)
    end if REQUIRED_TYPES.include?(type_class.name)
  end
  data = catalog.relationship_graph.vertices.map(&:to_resource)
  format_resources(data).flatten
end

Puppet::Face.define(:inventory, '0.1.0') do
  summary 'Use Puppet as a way to inventory systems'
  action(:resources) do
    summary 'Discovery resources (including packages, services, users and groups)'
    when_invoked do |*_args|
      inventory_resources
    end
    when_rendering :console do |return_value|
      JSON.pretty_generate(return_value)
    end
  end

  action(:all) do
    summary 'Discover resources (including packages, services, users and groups) along with facts about the system'
    when_invoked do |*_args|
      {
        schema_version: 1,
        created: Time.now.utc.iso8601,
        resources: inventory_resources,
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
