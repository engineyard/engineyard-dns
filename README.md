# Simple DNS for Engine Yard AppCloud environments

Currently creates A records for a domain (.myapp.com and www.myapp.com) to
point to the public IP of an AppCloud environment.

You can use any DNS provider supported by fog, including AWS Route 53, Blue Box, DNSimple, Linode, Slicehost and Zerigo.

For example:

<img src="https://img.skitch.com/20110523-x5mhutfr8r79parhuq7r44sqma.png">

NOTE: This image is an artist's impression. Probably an artist who doesn't know how
HTTP requests and DNS work. HTTP reqests don't go through DNSimple (or any DNS nameserver).
The host in the URL is translated from myapp.com into an IP address (e.g. 1.2.3.4) by DNS. 
The HTTP request then goes to the IP address. But the picture looks nice.

## Usage

First, setup DNS credentials in `~/.fog` (see below).

Basic usage is very simple. Assuming you have registered `myapp.com`
with one of your DNS providers, the following will automatically work:

    $ ey-dns assign myapp.com
    Found AppCloud environment giblets on account main with IP 1.2.3.4
    Found myapp.com in DNSimple account

    Assigning myapp.com --> 1.2.3.4 (drnic/myapp_production)
    Assigning www.myapp.com --> 1.2.3.4 (drnic/myapp_production)

If an AppCloud environment cannot be automatically detected, explicitly pass -e or -a flags
like the `ey` CLI itself:

    $ ey-dns assign myapp.com -e myapp_production

If .myapp.com or www.myapp.com already exist you will be prompted to override them.
You can force the override with the `--override` or `-o` flag.

## Setup

    $ gem install engineyard-dns

To setup credentials for AppCloud, run the following command for the first time and
you will be prompted for credentials:

    $ ey environments --all

To setup credentials for DNSimple, create a file `~/.fog` to look like:

    :default:
      :dnsimple_email:        EMAIL
      :dnsimple_password:     PASSWORD

To setup credentials for AWS Route 53, create a file `~/.fog` to look like:

    :default:
      :aws_access_key_id:     ACCESS_KEY
      :aws_secret_access_key: SECRET_ACCESS_KEY

If you have multiple DNS providers then add as many credentials within `:default`
as you like.

On Unix, make this file readable to you only:

    $ chmod 600 ~/.fog

Test you have fog working with your DNS provider:

    $ fog
    >> provider = 'DNSimple' # or 'AWS' or 'Slicehost' etc
    >> Fog::DNS.new({:provider => provider}).zones.all.map(&:domain)
    ["drnicwilliams.com", "emrubyconf.com", ...]


## Development

[![Build Status](http://travis-ci.org/engineyard/engineyard-dns.png)](http://travis-ci.org/engineyard/engineyard-dns)

The test suite is purely cucumber scenarios. No rspec tests are being used. There are credentials for http://test.dnsimple.com built into the test suite. You should not have to do anything to run the tests except:

    git clone git://github.com/engineyard/engineyard-dns.git
    cd engineyard-dns
    bundle
    bundle exec rake

## License

Copyright (c) 2010 Engine Yard, Inc

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
