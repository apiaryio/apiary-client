Apiary CLI Client
=================

[Apiary](https://apiary.io) CLI client, `apiary`.

[![Build Status](https://travis-ci.org/apiaryio/apiary-client.png?branch=master)](https://travis-ci.org/apiaryio/apiary-client) [![Build status](https://ci.appveyor.com/api/projects/status/0hmkivbnhf9p3f8d/branch/master?svg=true)](https://ci.appveyor.com/project/Apiary/apiary-client/branch/master)

## Description

The Apiary CLI Client gem is a command line tool for developing and previewing
[API Blueprint](http://apiblueprint.org) documents locally. It can also be
used for pushing updated documents to and fetching existing documents from
[Apiary](http://apiary.io).


Please see the `apiary help` command and the [full documentation](http://client.apiary.io) for an in-depth look in how to use this tool.

For instructions on making your  own changes, see [Hacking Apiary CLI Client](#hacking-apiary-cli-client), below.

## Installation

### Install as a Ruby gem

``` sh
gem install apiaryio
```

### Using Docker - alternative if you don't install ruby or installation not work for you

Download image:

```
docker pull apiaryio/client
```
Run instead `apiary` just `docker run apiaryio/client`

Build from source code:

```
docker build -t "apiaryio/client" .
```

### Setup Apiary credentials

*Required only for publish and fetch commands.*


1. Make sure you are a registered user of [Apiary](http://apiary.io).
2. Retrieve API key (token) on [this page](https://login.apiary.io/tokens).
3. Export it as an environment variable:

```sh
export APIARY_API_KEY=<your_token>
```
## Command-line Usage

```
$ apiary help
Commands:
  apiary fetch --api-name=API_NAME    # Fetch API Description Document from API_NAME.apiary.io
  apiary help [COMMAND]               # Describe available commands or one specific command
  apiary preview                      # Show API documentation in default browser
  apiary publish --api-name=API_NAME  # Publish API Description Document on docs.API_NAME.apiary.io
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
  [--output=FILE]      # Write API Description Document into specified file

Fetch API Description Document from API_NAME.apiary.io
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
  [--path=PATH]                      # Specify path to API Description Document. When given a directory, it will look for apiary.apib or swagger.yaml file
  [--api-host=HOST]                  # Specify apiary host
  [--server], [--no-server]          # Start standalone web server on port 8080
  [--port=PORT]                      # Set port for --server option
  [--host=HOST]                      # Set host for --server option

Show API documentation in default browser
```

#### publish

```
$ apiary help publish
Usage:
  apiary publish --api-name=API_NAME

Options:
  [--message=COMMIT_MESSAGE]  # Publish with custom commit message
  [--path=PATH]               # Specify path to API Description Document. When given a directory, it will look for apiary.apib or swagger.yaml file
  [--api-host=HOST]           # Specify apiary host
  --api-name=API_NAME         

Publish API Description Document on docs.API_NAME.apiary.io
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

## Hacking Apiary CLI Client

### Build

1.  If needed, install bundler:

    ```sh
    $ gem install bundler
    ```

2.  Clone the repo:

    ```sh
    $ git clone git@github.com:apiaryio/apiary-client.git
    $ cd apiary-client
    ```

3.  Install dependencies:

    ```sh
    $ bundle install
    ```

### Test

Inside the `apiary-client` repository directory run:

```sh
$ bundle exec rake test
$ bundle exec rake features
```


### Release

Use `bundle install` to install your changes locally, for manual and ad-hock testing.

Only gem owners `gem owner apiaryio` can publish new gem into [RubyGems](https://rubygems.org/gems/apiaryio).

```sh
$ rake release
```


## License

Copyright 2012-15 (c) Apiary Ltd.

Released under MIT license.
See [LICENSE](https://raw.githubusercontent.com/apiaryio/apiary-client/master/LICENSE) file for further details.
