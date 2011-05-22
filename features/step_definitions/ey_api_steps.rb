Given /^I have setup my engineyard email\/password for API access$/ do
  ENV['EYRC'] = File.join(@home_path, ".eyrc")
  token = { ENV['CLOUD_URL'] => {
      "api_token" => "f81a1706ddaeb148cfb6235ddecfc1cf"} }
  File.open(ENV['EYRC'], "w"){|f| YAML.dump(token, f) }
end

When /^I have "two accounts, two apps, two environments, ambiguous" in AppCloud$/ do
  api_scenario "two accounts, two apps, two environments, ambiguous"
end

# has a known public IP in its hostname ec2-174-129-7-113.compute-1.amazonaws.com
When /^I have "two apps" in AppCloud$/ do
  api_scenario "two apps"
end
