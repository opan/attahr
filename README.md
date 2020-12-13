# Atthar

Welcome to your new Hanami project!

## Setup

To use auto reloading:
1. Run server with `shotgun --port=2300` and on the other terminal run `bundle exec guard`.
2. Ensure to connect `livereload` in the browser until there is message printed the browser is connected

How to run tests:

```
% bundle exec rake
```

How to run the development console:

```
% bundle exec hanami console
```

How to run the development server:

```
% bundle exec hanami server
```

How to prepare (create and migrate) DB for `development` and `test` environments:

```
% bundle exec hanami db prepare

% HANAMI_ENV=test bundle exec hanami db prepare
```

Explore Hanami [guides](http://hanamirb.org/guides/), [API docs](http://docs.hanamirb.org/1.3.1/), or jump in [chat](http://chat.hanamirb.org) for help. Enjoy! 🌸
