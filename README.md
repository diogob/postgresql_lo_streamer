# postgresql_lo_streamer [![Build Status](https://secure.travis-ci.org/diogob/postgresql_lo_streamer.png)](http://travis-ci.org/diogob/postgresql_lo_streamer)

This gem adds to your application a controller that can read PostgreSQL Large Objects and stream them to a HTTP client.

For more information on PostgreSQL Large Objects you can take a look at the [official docs](http://www.postgresql.org/docs/9.2/static/largeobjects.html)

## Installation

Add it to your Gemfile:

    gem 'postgresql_lo_streamer'


Add to your `config/routes.rb` the mount url where you are going to retrieve the files.
The following example will create a route `/image_file/:id` where :id is the oid of the Large Object in the database:

    mount PostgresqlLoStreamer::Engine => "/image_file"

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

