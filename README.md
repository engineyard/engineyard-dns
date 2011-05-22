# Simple DNS for Engine Yard AppCloud environments

## Usage

Setup `ey` and `dnsimple` gems and credentials (see below).

    $ ey-dnsimple assign myapp.com
    Assigning myapp.com --> 1.2.3.4 (drnic/myapp_production)
    Created A record for myapp.com (id:12345)
    Complete!
    Found 1 records for myapp.com
    	.myapp.com (A)-> 1.2.3.4 (ttl:, id:12345)

If an AppCloud environment cannot be automatically detected, explicitly pass -e or -a flags
like the `ey` CLI itself:

    $ ey-dnsimple assign myapp.com -e myapp_production

## Setup

    $ gem install engineyard-dnsimple

This will install the `engineyard` and `dnsimple-ruby` gems as well.

To setup credentials for AppCloud, run the following command for the first time and
you will be prompted for credentials:

    $ ey environments --all

To setup credentials for DNSimple, create a file `~/.dnsimple` to look like:

    username: DNSIMPLE_USERNAME
    password: DNSIMPLE_PASSWORD

On Unix, make this file readable to you only:

    $ chmod 600 ~/.dnsimple

Test you have DNSimple working:

    $ dnsimple list
    Found 1 domains:
    	myapp.com

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
