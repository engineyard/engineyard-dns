require "engineyard"
require "engineyard/thor"
require "engineyard/cli"
require "engineyard/cli/ui"
require "engineyard/error"
require "dnsimple"
require "dnsimple/cli"

module EngineYard
  module DNSimple
    class CLI < Thor
      include EY::UtilityMethods
      # include Thor::Actions

      def self.start(*)
        Thor::Base.shell = EY::CLI::UI
        EY.ui = EY::CLI::UI.new
        super
      end


      desc "assign domain", "Assign domain (domain) to your AppCloud environment"
      method_option :verbose, :aliases     => ["-V"], :desc => "Display more output"
      method_option :environment, :aliases => ["-e"], :desc => "Environment in which to deploy this application", :type => :string
      method_option :account, :aliases     => ["-c"], :desc => "Name of the account you want to deploy in"
      def assign(domain)
        environment = fetch_environment(options[:environment], options[:account])
        unless environment.instances.first
          error "Environment #{account_name}/#{env_name} has no booted instances."
        end
        public_hostname = environment.instances.first.public_hostname
        status          = environment.instances.first.status
        unless public_hostname =~ /ec2-(\d+)-(\d+)-(\d+)-(\d+)/
          error "Cannot determine public IP from current hostname #{public_hostname}"
        end
        
        account_name, env_name = environment.account.name, environment.name
        
        ::DNSimple::Client.load_credentials_if_necessary
        
        public_ip = "#{$1}.#{$2}.#{$3}.#{$4}"
        say "Assigning #{domain} --> #{public_ip} (#{account_name}/#{env_name})"

        ::DNSimple::Commands::CreateRecord.new.execute([domain, "", "A", public_ip, ""]) # A record for .mydomain.com

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
    end
  end
end
