# ChangeLog

## v0.5.0 - 2011/5/24

* "ey-dns domains" lists the registered domains for each DNS provider (with a count of records for each)

## v0.4.0 - 2011/5/23

* supporting many DNS providers via fog
* automatic discovery of which DNS provider hosts your domain
* see README for setting up fog credentials

## v0.3.0 - 2011/5/22

* ey-dns assign DOMAIN NAME - can pass a subdomain name (only that record is created)

## v0.2.0 - 2011/5/22

* If [domain, name] pair already exists then prompt for override

## v0.1.2 - 2011/5/22

* Cucumber scenario is now working against http://test.dnsimple.com
* Worth rereleasing gem just to celebrate

## v0.1.1 - 2011/5/22

* Create .myapp.com and www.myapp.com A records

## v0.1.0 - 2011/5/22

* Initial release
* Basic implementation of `ey-dns assign DOMAIN`
