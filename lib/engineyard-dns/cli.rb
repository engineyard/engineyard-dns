require "engineyard"
require "engineyard/thor"
require "engineyard/cli"
require "engineyard/cli/ui"
require "engineyard/error"
require "fog"
require "fog/bin"
require "ipaddress"

module EngineYard
  module DNS
    class CLI < Thor
      include EY::UtilityMethods

      def self.start(*)
        Thor::Base.shell = EY::CLI::UI
        EY.ui = EY::CLI::UI.new
        super
      end

      desc "assign DOMAIN [SUBDOMAIN]", "Assign DNS domain/tld (or name.tld) to your AppCloud environment"
      method_option :environment, :aliases => ["-e"], :desc => "Environment containing the IP to which to resolve", :type => :string
      method_option :account,     :aliases => ["-c"], :desc => "Name of the account where the environment is found"
      method_option :force,       :aliases => ["-f"], :desc => "Override DNS records if they already exist", :type => :boolean
      def assign(domain_name, subdomain = "")
        $stdout.sync
        say "Fetching AppCloud environment information..."
        environment = fetch_environment(options[:environment], options[:account])

        public_ip = fetch_public_ip(environment)

        say ""
        say "Searching for #{domain_name} amongst your DNS providers..."

        domain, provider_name = find_domain(domain_name)
        unless domain
          error "Please register domain #{domain_name} with your DNS provider"
        end
        say "Found #{domain_name} in #{provider_name} account"
        say ""

        assign_dns(domain, environment.account.name, environment.name, public_ip, subdomain, options[:force])
        assign_dns(domain, environment.account.name, environment.name, public_ip, "www", options[:force]) if subdomain == ""

        say "Complete!", :green
      end

      desc "domains", "List available domains/zones from your DNS providers"
      def domains
        dns_provider_names.each do |provider_name|
          dns_provider = ::Fog::DNS.new({:provider => provider_name})
          domains      = dns_provider.zones

          if domains.size == 0
            say "#{provider_name}: ", :yellow; say "none"
          else
            say "#{provider_name}:", :green
            domains.each do |domain|
              records = domain.records.all
              say "  #{domain.domain} - #{records.size} records"
            end
          end
        end
      end

      desc "version", "show version information"
      def version
        require 'engineyard-dns/version'
        say EngineYard::DNS::VERSION
      end

      map "-v" => :version, "--version" => :version, "-h" => :help, "--help" => :help

      private
      def say(msg, color = nil)
        color ? shell.say(msg, color) : shell.say(msg)
        $stdout.flush
      end

      def display(text)
        say text
        exit
      end

      def error(text)
        say "ERROR: #{text}", :red
        exit(1)
      end

      # Return the public IP assigned to an environment (which may or may not be a booted cluster of instances)
      # Displays error and exits if no public IP assigned to the environment
      def fetch_public_ip(environment)
        unless environment.load_balancer_ip_address
          error "#{environment_display environment} has no assigned public IP address."
        end

        say "#{environment_display environment} has IP #{environment.load_balancer_ip_address}"
        environment.load_balancer_ip_address
      end

      # Discover which DNS provider (DNSimple, etc) is controlling +domain_name+ (a zone)
      # and return [domain/zone, provider name]
      #
      # TODO remove hard-wiring for dnsimple; and discover which provider hosts domain/zone
      # TODO how to get provider name (2nd result) from fog's Zone class? (no need to return 2nd arg)
      def find_domain(domain_name)
        dns_provider_names.each do |provider|
          dns_provider = ::Fog::DNS.new({:provider => provider})
          if domain = dns_provider.zones.select {|z| z.domain == domain_name}.first
            return [domain, provider]
          end
        end
        [nil, nil]
      end

      def assign_dns(domain, account_name, env_name, public_ip, subdomain = "", override = false)
        if record = domain.records.select {|r| r.name == subdomain}.first
          if override || ask_override_dns?(domain, subdomain)
            record.destroy
            say "Deleted #{domain_name domain, subdomain}"
          else
            error "Cannot replace existing #{domain_name domain, subdomain} DNS"
          end
        end
        say "Assigning "
        say "#{domain_name domain, subdomain} ", :green
        say "--> "
        say "#{public_ip} ", :green
        say "(#{account_name}/#{env_name})"

        record = domain.records.create(:ip => public_ip, :name => subdomain, :type => record_type(public_ip), :ttl => "60")
        say "Created A record for #{domain_name domain, subdomain}"
      end

      # "A" for IPv4 and "AAAA" for IPv6; else display error and exit
      def record_type(public_ip)
        address = IPAddress(public_ip)
        if address.ipv4?
          "A"
        elsif address.ipv6?
          "AAAA"
        else
          error "Cannot recognize IP #{public_ip} as either IPv4 or IPv6 format"
        end
      end

      def ask_override_dns?(domain, name)
        ui = EY::CLI::UI::Prompter.backend
        ui.agree("Replace #{domain_name domain, name}: ", "y")
      end

      # "myapp.com", "name" => "name.myapp.com"
      # "myapp.com", ""     => "myapp.com"
      def domain_name(domain, name = nil)
        if name && name.length > 0
          "#{name}.#{domain.domain}"
        else
          domain.domain
        end
      end

      # Returns the list of DNS providers that the current user has access to
      # Includes the +fog_dns_providers+ list
      # TODO find credentials in alternate locations (e.g. ~/.dnsimple)
      def dns_provider_names
        fog_dns_provider_names
      end

      # Returns the list of DNS providers that the current user has fog credentials
      # TODO how do I get the base list from fog?
      def fog_dns_provider_names
        ['AWS', 'Bluebox', 'DNSimple', 'Linode', 'Slicehost', 'Zerigo'] & Fog.providers
      end
      
      def environment_display(environment)
        "AppCloud environment #{environment.account.name}/#{environment.name}"
      end

    end
  end
end
