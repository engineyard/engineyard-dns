# Simple DNS for Engine Yard Cloud with DNSimple

For me, one of the things I liked to do with a new Engine Yard Cloud application is to attached a pretty domain. The default AWS EC2 URL doesn't glorify my fine efforts.

To make setting up DNS easier with Engine Yard Cloud, we've released the `ey-dns` command line application as an open source project ([readme](https://github.com/engineyard/engineyard-dns#readme)).

It's really quite easy to use:

1. Register your application's domain with a DNS provider (see supported list below), such as DNSimple.
2. Transfer your domain to the DNS provider or change to use their name servers, such as ns1.dnsimple.com (ns2, ns3, etc) for DNSimple.
3. Install and run the command line application within your Rails/Ruby app:

    $ gem install engineyard-dns
    $ cd path/to/my/app
    $ ey-dns apply myapp.com
    Assigning myapp.com --> 1.2.3.4 (drnic/myapp_production)
    Assigning www.myapp.com --> 1.2.3.4 (drnic/myapp_production)

If you have previously assigned the domain records to another host, it will prompt you to change them. 

If there is any confusion about which Engine Yard Cloud environment is hosting your application, it will show you your options and then you can use the `--environment` and `--account` options to be more specific:

    $ ey-dns apply myapp.com --environment myapp_production
    $ ey-dns apply myapp.com staging --environment myapp_staging

## Supported DNS providers

This tool will automatically determine which DNS provider is managing the domain/zone that you are wiring up to your Engine Yard Cloud environment.

The `ey-dns` uses [fog](https://github.com/geemus/fog) to access DNS providers. The current list of available DNS providers for fog is: AWS, Bluebox, DNSimple, Linode, Slicehost, Zerigo. The next section shows how to setup fog credentials.

## DNS credentials

To access your DNS provider, you need to add your account/API credentials into `~/.fog` file. I currently have DNS access to DNSimple, Slicehost and AWS Route 53. My `~/.fog` file looks a little bit like:

    :default:
      :dnsimple_email:        MYEMAIL
      :dnsimple_password:     XXXXXXXXXXX
      :aws_access_key_id:     0NJRCXXXXXXXXXXXX
      :aws_secret_access_key: QGtnbXXXXXXXXXXXX/qQ4lXXXXXXXXXXXXXX
      :slicehost_password:    f9a265f66XXXXXXXXXXXXXXXXXXXXXXXXXXX

### DNSimple credentials

I currently use [DNSimple](https://dnsimple.com/r/a72aa4340dce68) for registering and serving all my new domains. Their API credentials are the same email/password you use to login to the service. 

Note the surreptitious referral used here, giving me a free month for each DNSimple sign-up, bwhahahaha. To avoid gifting me a free month, use [http://dnsimple.com](http://dnsimple.com/) link. A free month isn't as cool as free swag, but I don't think DNSimple has free swag. Well, I don't have any of it.

### AWS credentials

Recently AWS began offering an API-driven DNS server [Route 53](http://aws.amazon.com/route53/). The AWS credentials for access DNS are the same credentials you use in CarrierWave or PaperClip to access AWS S3. To find them, log into your [AWS Account](http://aws.amazon.com/account/) and navigate to "Security Credentials", then "Access Credentials",
and click "Show" to see your secret access key.

<img src="https://img.skitch.com/20110524-m7d5js2nrfwxynbw14hh9qqf3f.png">

### Slicehost credentials

Until I switched to DNSimple and to fog, I used Slicehost for its [API/CLI-driven](https://github.com/cameroncox/slicehost-tools) DNS. I still have many domains managed by Slicehost. To enable API access to your Slicehost account in `fog` (and hence `ey-dns`) go to [https://manage.slicehost.com/api](https://manage.slicehost.com/api), enabled API access and copy your API token into the `slicehost_password` field of `~/.fog` above.

<img src="https://img.skitch.com/20110524-jbmkcwumrdgw2pgrt7kpe1mbga.png">

### Testing credentials

You can test your DNS credentials with the `ey-dns domains` command:

    $ ey-dns domains
    AWS: none
    DNSimple:
      drnicwilliams.com - 0 records
      emrubyconf.com - 2 records
      mocra.com - 27 records
    Slicehost:
      myconfplan.com. - 0 records

## Summary

Hopefully this tool makes it much easier to setup or change DNS for your Engine Yard Cloud environments. Let us know in the comments or in the project's [Issues](https://github.com/engineyard/engineyard-dns/issues) if you love it, find bugs or have feature requests.

The source and instructions for the project is [available on GitHub](https://github.com/engineyard/engineyard-dns#readme).
