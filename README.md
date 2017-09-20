# postgresql_lo_streamer [![Build Status](https://travis-ci.org/diogob/postgresql_lo_streamer.svg?branch=master)](https://travis-ci.org/diogob/postgresql_lo_streamer)

This gem adds to your application a controller that can read PostgreSQL Large Objects and stream them to a HTTP client.

For more information on PostgreSQL Large Objects you can take a look at the [official docs](http://www.postgresql.org/docs/current/static/largeobjects.html)

## Installation

Add it to your Gemfile:

    gem 'postgresql_lo_streamer'

### Configuration

You can adjust default file streaming headers by tweaking configuration options:

    PostgresqlLoStreamer.configure do |config|
      config.options = {:type => 'image/png', :disposition => 'inline'}
    end

Add to your `config/routes.rb` the mount url where you are going to retrieve the files.
The following example will create a route `/image_file/:id` where :id is the oid of the Large Object in the database:

    mount PostgresqlLoStreamer::Engine => "/image_file"

## Passing mime-type with url

If you specify an extension with your url, the default file streaming headers will be overridden.

```ruby
/file/38681 #=> image/png
/file/38681.jpg #=> image/jpeg
/file/38681.css #=> text/css
```

This allows you to dynamically stream resources of different types and send appropriate headers. Please note that only the following types will be sent with an inline disposition, otherwise, it will be sent as an attachment, forcing a download.

  image/jpeg
  image/png
  image/gif
  image/svg+xml
  text/css
  text/plain

In order for this to work in practice, you will likely need to store the extension or the url in the database alongside the oid when saving the file.

## Using it with carrierwave-postgresql

If you are storing your files in the database using the [carrierwave-postgresql](http://diogob.github.com/carrierwave-postgresql/) gem, then your model will generate an URL like `/<mode_name>_<attribute_name>/<oid>`.

So, for our previous example, if you have a model called `Image`, with and attribute called `file` (which is the oid referencing the Large Object), then the model will generate the URL matching our example. If you have more than one large object attribute in your database you can mount this engine multiple times with different URLs.

## Contributing to postgresql_lo_streamer

 * Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
 * Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
 * Fork the project.
 * Start a feature/bugfix branch.
 * Commit and push until you are happy with your contribution.
 * Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
 * Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 Diogo Biazus. See MIT-LICENSE for
further details.

