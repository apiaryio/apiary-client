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

```
$ apiary help
Commands:
  apiary fetch --api-name=API_NAME    # Fetch apiary.apib from API_NAME.apiary.io
  apiary help [COMMAND]               # Describe available commands or one specific...
  apiary preview                      # Show API documentation in default browser
  apiary publish --api-name=API_NAME  # Publish apiary.apib on docs.API_NAME.apiary.io
  apiary version                      # Show version

```

### Details

#### fetch

```
$ apiary help fetch
Usage:
  apiary fetch --api-name=API_NAME

Options:
  --api-name=API_NAME  
  [--api-host=HOST]    # Specify apiary host
  [--output=FILE]      # Write apiary.apib into specified file

Fetch apiary.apib from API_NAME.apiary.io
```

#### preview

```
$ apiary help preview
Usage:
  apiary preview

Options:
  [--browser=chrome|safari|firefox]  # Show API documentation in specified browser
                                     # Possible values: chrome, safari, firefox
  [--output=FILE]                    # Write generated HTML into specified file
  [--path=PATH]                      # Specify path to blueprint file
                                     # Default: apiary.apib
  [--api-host=HOST]                  # Specify apiary host
  [--server], [--no-server]          # Start standalone web server on port 8080
  [--port=PORT]                      # Set port for --server option

Show API documentation in default browser
```

#### publish

```
$ apiary help publish
Usage:
  apiary publish --api-name=API_NAME

Options:
  [--message=COMMIT_MESSAGE]  # Publish with custom commit message
  [--path=PATH]               # Specify path to blueprint file
                              # Default: apiary.apib
  [--api-host=HOST]           # Specify apiary host
  --api-name=API_NAME         

Publish apiary.apib on docs.API_NAME.apiary.io
```

#### version

```
$ apiary help version
Usage:
  apiary version

Options:
  [--{:aliases=>"-v"}={:ALIASES=>"-V"}]  

Show version
```

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
