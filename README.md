# Flourish

Universal Income Application

This project centres around the idea of universal basic income.

Members will make contributions, and the pool of contributions will be split evenly between members each week.

## Framework

Flourish is a [Ruby on Rails application](https://rubyonrails.org/)

Current major version is 7.2.1

Check out the [Rails Guides](https://guides.rubyonrails.org/index.html) to get up and running.

- [Getting Started with Rails](https://guides.rubyonrails.org/getting_started.html)

## Ruby version

- `3.3.5`

## Database initialization and creation

[PostgreSQL](https://www.postgresql.org/) is required.

```bash
$ rails db:setup
```

*This will also load seed data, see db/seeds.rb

## Test Suite

Current coverage is unit tests for models, controllers, and service classes.

```bash
$ rails test
```

## External Services

Flourish makes use of Mailgun and Paypal. 

## Feedback

[Issues](https://github.com/cassar/flourish/issues) can be submitted for feature requests and bugs.

General questions and thoughts can be posted in [discussions](https://github.com/cassar/flourish/discussions)

## Design Documents

Design documents documenting project and intent and idiosyncrasies and design decisions can be found in the [repo wiki](https://github.com/cassar/flourish/wiki).
