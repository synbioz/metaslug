# Metaslug

Metaslug allows you to map url to metas by locale.
Locale files should be presents in `config/metaslug`, but there is a task to
generate them using your defined routes.

~~~
bundle exec rails generate metaslug:config
~~~

It will generate files like:

~~~
en:
  default:
    description: "Default description"
    title: "Default title"
  "/posts":
    description: ""
    title: ""
  "/posts/:id/edit":
    description: ""
    title: ""
~~~

On development mode, translations are reloaded for each request, not in the other
environments.

## Tests

You can run the integration tests using:

~~~
bundle exec rake test
~~~

## Warning

You may encounter a problem if you change locale in a filter, because metas are loaded in a before_filter on top on the application controller.

The best way to avoid this is to use `prepend_before_filter` to ensure your filters will be processed first.

## Roadmap

This is what we planned to add next:

- Create `config/metaslug` directory automatically
- Manage more complicated metas
- Ability to add dymamic content in metas
- Finalize generator (install, locale…)
- Add default translation in generator
- Different storage (database, cache…)
- Web interface to edit metas from the app
