Given /^I have setup my fog credentials for "([^"]*)"$/ do |provider|
  setup_dns_credentials(provider)
end

Given /^I have not setup my fog credentials$/ do
  remove_dns_credentials
end

Given /^I have DNS domain "([^"]*)" with provider "([^"]*)"$/ do |domain, provider|
  setup_domain(provider, domain)
end
