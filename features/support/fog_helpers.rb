module FogHelpers
  def setup_dns_credentials(provider)
    email, password = "ossgrants+dns@engineyard.com", "ossgrants1"
    File.open(fog_credentials_file, "w") do |file|
      @credentials = case provider.to_sym
      when :DNSimple
        { :dnsimple_email => email, :dnsimple_password => password}
      else
        raise "No credentials available for provider '#{provider}'"
      end
      file << YAML::dump(:default => @credentials)
    end
  end
  
  def remove_dns_credentials
    FileUtils.rm_rf(fog_credentials_file)
  end
  
  def setup_domain(provider, domain)
    dns_provider(provider).zones.select { |z| z.domain == domain }.each { |z| z.destroy }
    dns_provider(provider).zones.create(:domain => domain)
  end
  
  def dns_provider(provider)
    @dns_provider ||= Fog::DNS.new({:provider => provider})
  end
  
  def fog_credentials_file
    File.expand_path("#{ENV['HOME']}/.fog")
  end
end
World(FogHelpers)
