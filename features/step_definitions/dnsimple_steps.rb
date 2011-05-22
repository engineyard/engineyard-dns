Given /^I have setup my dnsimple credentials$/ do
  setup_dnsimple_credentials
end

Given /^I have DNSimple domain "([^"]*)"$/ do |domain|
  create_dnsimple_domain domain
end


