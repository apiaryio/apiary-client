apiaryio
=============

Apiary.io CLI 

[![Build Status](https://travis-ci.org/apiaryio/apiary-client.png?branch=travis)](https://travis-ci.org/apiaryio/apiary-client)


## Install

``` bash
gem install apiaryio
```


## Description

Apiaryio gem provides a way to test and display your API documentation on your local
machine, either using static files or using a standalone web server...

## Usage

    $ apiary help

    Usage: apiary command [options]
    Try 'apiary help' for more information.

    Currently available apiary commands are:

      preview                                     Show API documentation in default browser
      preview --browser [chrome|safari|firefox]   Show API documentation in specified browser
      preview --path [PATH]                       Specify path to blueprint file
      preview --api_host [HOST]                   Specify apiary host
      preview --server                            Start standalone web server on port 8080
      preview --server --port [PORT]              Start standalone web server on specified port
      okapi     help                              Show okapi testing tool help
      help                                        Show help

      version                                     Show version

## Copyright

Copyright 2012 (c) Apiary Ltd.

## Contributors

- Jakub Nešetřil
- James Charles Russell
- Lukáš Linhart
- Emili Parreño
- Peter Grilli [Tu1ly]

## License

Released under MIT license. See LICENSE file for further details.
