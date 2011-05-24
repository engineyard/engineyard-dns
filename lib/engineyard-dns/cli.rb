require "engineyard"
require "engineyard/thor"
require "engineyard/cli"
require "engineyard/cli/ui"
require "engineyard/error"
require "dnsimple"
require "dnsimple/cli"

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
      def assign(domain, name = "")
        say "Fetching AppCloud environment information..."; $stdout.flush
        
        environment = fetch_environment(options[:environment], options[:account])
        account_name, env_name = environment.account.name, environment.name
        unless environment.instances.first
          error "Environment #{account_name}/#{env_name} has no booted instances."
        end
        public_hostname = environment.instances.first.public_hostname
        status          = environment.instances.first.status
        unless public_hostname =~ /ec2-(\d+)-(\d+)-(\d+)-(\d+)/
          error "Cannot determine public IP from current hostname #{public_hostname}"
        end
        
        public_ip = "#{$1}.#{$2}.#{$3}.#{$4}"

        say "Found AppCloud environment #{env_name} on account #{account_name} with IP #{public_ip}"        
        $stdout.flush

        ::DNSimple::Client.load_credentials_if_necessary
        assign_dns(account_name, env_name, domain, public_ip, name, options[:override])
        assign_dns(account_name, env_name, domain, public_ip, "www", options[:override]) if name == ""

        say "Complete!", :green
        
        ::DNSimple::Commands::ListRecords.new.execute([domain])
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
      
      def assign_dns(account_name, env_name, domain, public_ip, name = "", override = false)
        records = ::DNSimple::Record.all(domain)
        if record = records.find { |record| record.name == name && record.domain.name == domain }
          if override || ask_override_dns?(domain, name)
            ::DNSimple::Commands::DeleteRecord.new.execute([domain, record.id]) # A record for .mydomain.com
          else
            error "Cannot replace existing #{domain_name domain, name} DNS"
          end
        end
        say "Assigning "; say "#{domain_name domain, name} ", :green; say "--> "; say "#{public_ip} ", :green; say "(#{account_name}/#{env_name})"
        $stdout.flush
        
        ::DNSimple::Commands::CreateRecord.new.execute([domain, name, "A", public_ip, "60"]) # A record for .mydomain.com
      end
      
      def ask_override_dns?(domain, name)
        ui = EY::CLI::UI::Prompter.backend
        ui.agree("Replace #{domain_name domain, name}: ", "y")
      end
      
      def domain_name(domain, name = nil)
        if name && name.length > 0
          "#{name}.#{domain}"
        else
          domain
        end
      end
    end
  end
end
