# Simple DNS for AppCloud with DNSimple

For me, one of the things I liked to do with a new AppCloud application is to attached a pretty domain. The default AWS EC2 URL doesn't glorify my fine efforts.

I've started using the new [DNSimple](http://dnsimple.com/) as my DNS registrar and name server, and I believe an increasing number of AppCloud customers are too.

To make setting up DNS easier with AppCloud, we've released the `ey-dns` command line application.

It's really quite easy to use:

1. Register your application's domain with [DNSimple](http://dnsimple.com/)
2. Transfer your domain to DNSimple or change the name servers to ns1.dnsimple.com (ns2, ns3, etc)
3. Install and run the command line application:

    $ gem install engineyard-dns
    $ cd path/to/my/app
    $ ey-dns apply myapp.com
    Assigning myapp.com --> 1.2.3.4 (drnic/myapp_production)
    Assigning www.myapp.com --> 1.2.3.4 (drnic/myapp_production)

If you have previously assigned the domain records to another host, it will prompt you to change them. 

If there is any confusion about which AppCloud environment is hosting your application, it will show you your options and then you can use the `--environment` and `--account` options to be more specific:

    $ ey-dns apply myapp.com --environment myapp_production
    $ ey-dns apply myapp.com staging --environment myapp_staging

## Available domains/zones

This tool will automatically determine which DNS provider is managing the domain/zone that you are wiring up to your AppCloud environment.

## DNS credentials

To access your DNS provider, you need to add your account/API credentials into `~/.fog` file. I currently have DNS access to DNSimple, Slicehost and AWS Route 53. My `~/.fog` file looks a little bit like:

    :default:
      :aws_access_key_id:     0NJRCXXXXXXXXXXXX
      :aws_secret_access_key: QGtnbXXXXXXXXXXXX/qQ4lXXXXXXXXXXXXXX
      :dnsimple_email:        MYEMAIL
      :dnsimple_password:     XXXXXXXXXXX
      :slicehost_password:    f9a265f66XXXXXXXXXXXXXXXXXXXXXXXXXXX

### AWS credentials

Recently AWS began offering an API-driven DNS server "Route 53".

### Slicehost credentials

Until I switched to DNSimple, I used Slicehost for its CLI-driven DNS. I still have many domains managed by Slicehost. To enable API access to your Slicehost account in `fog` (and hence `ey-dns`) go to [https://manage.slicehost.com/api](https://manage.slicehost.com/api), enabled API access and copy your API token into the `slicehost_password` field of `~/.fog` above.

<img src="https://img.skitch.com/20110524-jbmkcwumrdgw2pgrt7kpe1mbga.preview.png">

## Summary

Hopefully this tool makes it much easier to setup or change DNS for your AppCloud environments. Let us know in the comments or in the project's [Issues](https://github.com/engineyard/engineyard-dns/issues) if you love it, find bugs or have feature requests.

The source and instructions for the project is [available on GitHub](https://github.com/engineyard/engineyard-dns#readme).
