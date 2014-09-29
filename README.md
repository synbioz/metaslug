# Metaslug

Metaslug allows you to map url to metas by locale.
You can define slug '/awesome-page' will have title 'Awesome' with other custom metas.

Metaslug uses liquid to be able to add dynamic content in the metas.

## Starting

First add the `metaslug` helper in your layout then use the install generator:

~~~
doctype html
html lang="fr"
  head
    meta charset="utf-8"
    = metaslug
~~~

~~~
bundle exec rails generate metaslug:install
~~~

It will create the `config/metaslug` folder and add an initializer.
Locale files should be presents in this directory, but there is a task to help you generating them using your defined routes.

~~~
bundle exec rails generate metaslug:locale
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

This generator takes options. For example:

~~~
bundle exec rails g metaslug:locale -l eueui -o -m description,keywords,title
~~~

will take generate a file for de locale. `-o` specifies to only print content on the console while `-m` takes your metas (defaults are title and description).

On development mode, translations are reloaded for each request, not in the other environments.

You can edit your locale file to add static or dynamic content.

~~~
en:
  default:
    description: "Default description"
    title: "Default title"
  "/my-page":
    description: ""
    title: "Title"
  "/posts/:id/edit":
    description: "Edit a post"
    title: "Edit post with title {{post.title}}"
~~~

We use liquid templates to be able to add dynamic content, based on your vars.
All you have to do is to allow methods in your model, and add allow variable in your controllers (they must be instance variable).
`metaslug_vars` is just a before_filter and can take the exact same options, like only, except…

~~~
class Post < ActiveRecord::Base
  liquid_methods :title
end
~~~

~~~
class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  metaslug_vars :post, only: :edit

  private
    def set_post
      @post = Post.find(params[:id])
    end
end
~~~

## Tests

You can run the integration tests using:

~~~
bundle exec rake test
~~~

## Warning

Metaslug overrides the default render method, to be able to use dynamic metas.
We need to access the vars setted after action and interpolate them before rendering.

## Roadmap

This is what we planned to add next:

- Different storage (database, cache…)
- Web interface to edit metas from the app
- Remove rails dependency
