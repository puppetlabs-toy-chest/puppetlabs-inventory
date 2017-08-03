module PuppetX
  module Puppetlabs
    class Inventory
      REQUIRED_TYPES = %i[group package service user lumogon].freeze

      attr_accessor :catalog

      def initialize(with_resources: true)
        Puppet::Type.loadall
        Puppet.initialize_facts

        @catalog = Puppet::Resource::Catalog.new
        Puppet::Type.eachtype do |type_class|
          if REQUIRED_TYPES.include?(type_class.name)
            begin
              type_class.instances.each do |i|
                i = i.to_resource if with_resources
                catalog.add_resource(i)
              end
            rescue StandardError # rubocop:disable Lint/HandleExceptions
              # Individual types should be able to fail without the
              # whole run failing.
            end
          end
        end
      end

      def generate
        format_resources(@catalog.vertices).flatten
      end

      private

      def nil_or_absent?(thing)
        thing.nil? || thing == :absent
      end

      def format_resources(array)
        array.map do |hash| # rubocop:disable Metrics/BlockLength
          case hash.type
          when 'Package'
            {
              title: hash.title.to_s,
              resource: hash.type.downcase,
              provider: hash[:provider],
              versions: Array(hash[:ensure]).map(&:to_s)
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
          when 'Lumogon'
            response = {
              title: hash.title.to_s,
              resource: 'container',
              hostname: hash[:hostname],
              id: hash[:id],
              os: hash[:os],
              platform: hash[:platform],
              platformfamily: hash[:platformfamily],
              platformversion: hash[:platformversion]
            }
            %i[dpkg rpm apk labels].each do |capability|
              response[capability] = hash[capability] unless nil_or_absent?(hash[capability])
            end
            response
          end
        end
      end
    end
  end
end
