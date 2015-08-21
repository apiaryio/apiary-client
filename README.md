apiaryio
=============

Apiary.io CLI

[![Build Status](https://travis-ci.org/apiaryio/apiary-client.png?branch=master)](https://travis-ci.org/apiaryio/apiary-client) [![Build status](https://ci.appveyor.com/api/projects/status/0hmkivbnhf9p3f8d/branch/master?svg=true)](https://ci.appveyor.com/project/Apiary/apiary-client/branch/master)


## Install

**install gem** (required)
``` bash
gem install apiaryio
```

**setup APIARY.io credentials** (required for publish and fetch command only)

1. Retrieve APIKEY on `https://login.apiary.io/tokens`
2. Save it to your environment variables :

```bash
export APIARY_API_KEY=<your_token_retrieved_on_step_1>
```

## Description

The Apiary CLI gem is a command line tool for developing and previewing
API Blueprint documents locally. It can also be used for pushing
updated documents to and fetching existing documents from Apiary.io.

Please see the [full documentation](http://client.apiary.io) for an in-depth
look in how to use this tool.

## Usage

    $ apiary help

    Usage: apiary command [options]
    Try 'apiary help' for more information.

    Currently available apiary commands are:

      preview                                     Show API documentation in default browser
      		  --browser [chrome|safari|firefox]   Show API documentation in specified browser
      		  --output [FILE]                     Write generated HTML into specified file
      		  --path [PATH]                       Specify path to blueprint file
      		  --api_host [HOST]                   Specify apiary host
      		  --server                            Start standalone web server on port 8080
      		  --server --port [PORT]              Start standalone web server on specified port
      publish --api-name [API_NAME]               Publish apiary.apib on docs.API_NAME.apiary.io
			  --path PATH						  Specify path to blueprint file (default: apiary.apib)
			  --api-host HOST					  Specify apiary host
              --api-name [API_NAME] \
              --message [COMMIT_MESSAGE]          Publish with custom commit message
      fetch   --api-name [API_NAME]               Fetch apiary.apib from API_NAME.apiary.io
			  --api-host [HOST]					  Specify apiary host
              --output [FILE]                     Write apiary.apib into specified file
      help                                        Show this help
      version                                     Show version

## Copyright

Copyright 2012-15 (c) Apiary Ltd.

## Contributors

- Jakub Nešetřil
- James Charles Russell [botanicus]
- Lukáš Linhart [Almad]
- Emili Parreño
- Peter Grilli [Tu1ly]
- Ladislav Prskavec
- Honza Javorek
- Matthew Rudy Jacobs
- Adam Kliment
- Jack Repenning
- Peter Strapp
- Pierre Merlin
- František Hába
- Benjamin Arthur Lupton

## License

Released under MIT license. See LICENSE file for further details.
