Apiary CLI Client
=================

[Apiary](https://apiary.io) CLI client, `apiary`.

[![Build Status](https://travis-ci.org/apiaryio/apiary-client.png?branch=master)](https://travis-ci.org/apiaryio/apiary-client) [![Build status](https://ci.appveyor.com/api/projects/status/0hmkivbnhf9p3f8d/branch/master?svg=true)](https://ci.appveyor.com/project/Apiary/apiary-client/branch/master)


## Description

The Apiary CLI Client gem is a command line tool for developing and previewing
[API Blueprint](http://apiblueprint.org) documents locally. It can also be
used for pushing updated documents to and fetching existing documents from
[Apiary](http://apiary.io).


## Usage

Please see the `apiary help` command and the [full documentation](http://client.apiary.io) for an in-depth look in how to use this tool.


## Installation

### Install as Ruby gem

```sh
gem install apiaryio
```

### Setup Apiary credentials

*Required only for `publish` and `fetch` commands.*

1. Make sure you are a registered user of [Apiary](http://apiary.io).
2. Retrieve API key (token) on [this page](https://login.apiary.io/tokens).
3. Export it as an environment variable:

```sh
export APIARY_API_KEY=<your_token>
```


## Hacking Apiary CLI Client

Fork & Pull Request! You are welcome to contribute. Use following steps to build & test Apiary CLI Client.

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

Use `bundle install` to test locally released version. Use `gem push` to
release a new version (refer to [RubyGems docs](http://guides.rubygems.org/publishing/) for further information).

```sh
$ gem push apiaryio-X.X.X.gem
```


## License

Copyright 2012-15 © Apiary Ltd.

Released under MIT license. See [LICENSE](https://raw.githubusercontent.com/apiaryio/apiary-client/master/LICENSE) file for further details.
