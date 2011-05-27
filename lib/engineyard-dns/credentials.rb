require 'pathname'

module EngineYard
  module DNS
    #
    # Credentials allows you to take a credentials path and write an example
    # credentials file if the file does not exist.
    #
    #     Credentials.new(Fog.credentials_path).write_if_missing do |pretty_path|
    #       # only yielded if example file is written
    #       puts "We wrote your file to #{pretty_path}"
    #     end
    #
    class Credentials

      EXAMPLE = <<-CREDENTIALS
:default:
  :aws_access_key_id:     ACCESSKEY
  :aws_secret_access_key: SECRETKEY
  :bluebox_customer_id:   ID
  :bluebox_api_key:       APITOKEN
  :dnsimple_email:        EMAIL
  :dnsimple_password:     PASSWORD
  :linode_api_key:        APITOKEN
  :slicehost_password:    APITOKEN
  :zerigo_email:          EMAIL
  :zerigo_token:          APITOKEN
      CREDENTIALS

      # fog_creds_path usually comes from Fog.credentials_path
      def initialize(fog_creds_path)
        self.path = fog_creds_path
      end

      attr_reader :path

      # Assign the fog credential path.
      #
      # Converts input to a Pathname and expands it.
      def path=(new_path)
        @path = Pathname.new(new_path).expand_path
      end

      # Writes an example credentials file to the default Fog.credentials_path
      #
      # This method will yield the path to which the example file was written.
      # If the credentials path exists, does nothing and does not yield.
      def write_if_missing
        unless path.exist?
          write_example
          yield pretty_path if block_given?
        end
      end

      private

      # Write the example credentials file to the initialized path.
      def write_example
        path.open("w") { |file| file << EXAMPLE }
        path.chmod(0600)
      end

      # Show the credentials path as ~/.fog instead of expanded /Users/me/.fog
      def pretty_path
        if Pathname.new("~/.fog").expand_path == path
          "~/.fog"
        else
          path.to_s
        end
      end
    end
  end
end
