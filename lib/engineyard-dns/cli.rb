require "engineyard"
require "engineyard/thor"
require "engineyard/cli"
require "engineyard/cli/ui"
require "engineyard/error"
require "fog"
require "fog/bin"

module EngineYard
  module DNS
    class CLI < Thor
      include EY::UtilityMethods
      # include Thor::Actions

      def self.start(*)
        Thor::Base.shell = EY::CLI::UI
        EY.ui = EY::CLI::UI.new
        super
      end


      desc "assign DOMAIN [NAME]", "Assign DNS domain/tld (or name.tld) to your AppCloud environment"
      method_option :verbose, :aliases     => ["-V"], :desc => "Display more output"
      method_option :environment, :aliases => ["-e"], :desc => "Environment in which to deploy this application", :type => :string
      method_option :account, :aliases     => ["-c"], :desc => "Name of the account you want to deploy in"
      method_option :override, :aliases    => ["-o"], :type => :boolean, :desc => "Override DNSimple records if they already exist"
      def assign(domain_name, name = "")
        say "Fetching AppCloud environment information..."; $stdout.flush
        
        environment = fetch_environment(options[:environment], options[:account])
        account_name, env_name = environment.account.name, environment.name
        unless environment.instances.first
          error "Environment #{account_name}/#{env_name} has no booted instances."
        end
        public_hostname = environment.instances.first.public_hostname
        status          = environment.instances.first.status
        
        # TODO - use DNS client to convert public_hostname into IP address
        unless public_hostname =~ /ec2-(\d+)-(\d+)-(\d+)-(\d+)/
          error "Cannot determine public IP from current hostname #{public_hostname}"
        end
        public_ip = "#{$1}.#{$2}.#{$3}.#{$4}"

        say "Found AppCloud environment #{env_name} on account #{account_name} with IP #{public_ip}"        
        
        say ""
        say "Searching for myapp.com amongst your DNS providers..."; $stdout.flush

        domain, provider_name = find_domain(domain_name)
        unless domain
          error "Please register domain #{domain_name} with your DNS provider"
        end
        say "Found myapp.com in #{provider_name} account ossgrants+dns@engineyard.com"
        say ""
        
        assign_dns(domain, account_name, env_name, public_ip, name, options[:override])
        assign_dns(domain, account_name, env_name, public_ip, "www", options[:override]) if name == ""
          
        say "Complete!", :green
        
        # ::DNSimple::Commands::ListRecords.new.execute([domain])
      end
      
      desc "version", "show version information"
      def version
        require 'engineyard-jenkins/version'
        shell.say Engineyard::Jenkins::VERSION
      end

      map "-v" => :version, "--version" => :version, "-h" => :help, "--help" => :help

      private
      def say(msg, color = nil)
        color ? shell.say(msg, color) : shell.say(msg)
      end

      def display(text)
        shell.say text
        exit
      end

      def error(text)
        shell.say "ERROR: #{text}", :red
        exit
      end
      
      def watch_page_while(host, port, path)
        waiting = true
        while waiting
          begin
            Net::HTTP.start(host, port) do |http|
              req = http.get(path)
              waiting = yield req
            end
            sleep 1; print '.'; $stdout.flush
          rescue SocketError => e
            sleep 1; print 'x'; $stdout.flush
          rescue Exception => e
            puts e.message
            sleep 1; print '.'; $stdout.flush
          end
        end
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
      
      def assign_dns(domain, account_name, env_name, public_ip, name = "", override = false)
        if record = domain.records.select {|r| r.name == name}.first
          if override || ask_override_dns?(domain, name)
            record.destroy
          else
            error "Cannot replace existing #{domain_name domain, name} DNS"
          end
        end
        say "Assigning "; say "#{domain_name domain, name} ", :green; say "--> "; say "#{public_ip} ", :green; say "(#{account_name}/#{env_name})"
        $stdout.flush
        
        record = domain.records.create(:ip => public_ip, :name => name, :type => "A", :ttl => "60")
        say "Created A record for #{domain_name domain, name}"
      end
      
      def ask_override_dns?(domain, name)
        ui = EY::CLI::UI::Prompter.backend
        ui.agree("Replace #{domain_name domain, name}: ", "y")
      end
      
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
      
    end
  end
end
