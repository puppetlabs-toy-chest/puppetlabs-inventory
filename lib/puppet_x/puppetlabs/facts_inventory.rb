require 'facter'

module PuppetX
  module Puppetlabs
    class FactsInventory
      def initialize(ignore: [])
        @ignore_facts = ignore
      end

      def generate
        post_process(Facter.to_hash)
      end

      private
        def post_process(facts)
          @ignore_facts.each do |ignore|
            facts = facts.tap { |inner| inner.delete(ignore) }
          end
          facts
        end
    end
  end
end
