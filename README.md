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
	Commands:
	  apiary fetch --api-name=API_NAME    # Fetch apiary.apib from API_NAME.apiary.io
	  apiary help [COMMAND]               # Describe available commands or one specific...
	  apiary preview                      # Show API documentation in default browser
	  apiary publish --api-name=API_NAME  # Publish apiary.apib on docs.API_NAME.apiary.io
	  apiary version                      # Show version


Further documentation is available with `apiary help COMMAND` and at the [full documentation](http://client.apiary.io) site.

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
