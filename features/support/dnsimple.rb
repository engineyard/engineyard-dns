module DNSimpleHelpers
  def setup_dnsimple_credentials
    config_file = File.expand_path('~/.dnsimple')
    unless File.exists? config_file
      File.open(config_file, "w") do |file|
        file << <<-EOS.gsub(/^\s{8}/, '')
        username: ossgrants+dnsimple@engineyard.com
        password: dnsimple1
        site:     https://test.dnsimple.com/
        EOS
      end
    end
    require "dnsimple"
    DNSimple::Client.load_credentials(config_file)
  end
  
  def create_dnsimple_domain(domain)
    begin
      ::DNSimple::Commands::DeleteDomain.new.execute([domain])
    rescue => e
      $stderr.puts e.message
    end
    ::DNSimple::Commands::CreateDomain.new.execute([domain])
  end
end
World(DNSimpleHelpers)