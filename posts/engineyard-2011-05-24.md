# Simple DNS for AppCloud with DNSimple

For me, one of the things I liked to do with a new AppCloud application is to attached a pretty domain. The default AWS EC2 URL doesn't glorify my fine efforts.

I've started using the new [DNSimple](http://dnsimple.com/) as my DNS registrar and name server, and I believe an increasing number of AppCloud customers are too.

To make setting up DNS easier with AppCloud, we've released the `ey-dnsimple` command line application.

It's really quite easy to use:

1. Register your application's domain with [DNSimple](http://dnsimple.com/)
2. Transfer your domain to DNSimple or change the name servers to ns1.dnsimple.com (ns2, ns3, etc)
3. Install and run the command line application:

    $ gem install engineyard-dnsimple
    $ cd path/to/my/app
    $ ey-dnsimple apply myapp.com
    Assigning myapp.com --> 1.2.3.4 (drnic/myapp_production)
    Assigning www.myapp.com --> 1.2.3.4 (drnic/myapp_production)

    Found 2 records for myapp.com
    	.myapp.com (A)-> 1.2.3.4 (ttl:, id:12345)
    	www.myapp.com (A)-> 1.2.3.4 (ttl:, id:12346)

If you have previously assigned the domain records to another host, it will prompt you to change them. 

If there is any confusion about which AppCloud environment is hosting your application, it will show you your options and then you can use the `--environment` and `--account` options to be more specific:

    $ ey-dnsimple apply myapp.com --environment myapp_production
    $ ey-dnsimple apply myapp.com staging --environment myapp_staging

Hopefully this tool makes it much easier to setup or change DNS for your AppCloud environments. Let us know in the comments or in the project's [Issues](https://github.com/engineyard/engineyard-dnsimple/issues) if you love it, find bugs or have feature requests.

The source and instructions for the project is [available on GitHub](https://github.com/engineyard/engineyard-dnsimple#readme).
