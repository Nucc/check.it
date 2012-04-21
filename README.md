

The Code Review Tool
==============================

Check.it is a simple code review tool for Git focusing on easy usage.


How to install
==============

Environment
-----------

First you need to have Ruby (>=1.8.7) and rubygems packages on your machine.

I suggest you to follow the instructions on the next page:

  * https://help.ubuntu.com/community/RubyOnRails

Install the bundler gem that will manage the dependencies

    gem install bundler


Initializing the app
--------------------

Install dependencies to .gems directory (without --path the gems will be stored in your <code>$HOME/.gems</code>)

    bundle install --path .gems

(you may have to use <code>bundle update</code> before installing)

Create your database configuration in <code>config/database.yml</code> and migrate it. You can use the sample configuration file if you want to use sqlite3 database engine.

    cp config/database.yml.sample config/database.yml
    bundle exec rake db:migrate

Clone your repositories to <code>APP_DIR/repositories</code> directory (you can change its location in config/config.yml with repository_path variable).

    cd repositories
    git clone https://github.com/Nucc/check.it.git

<b>Important:</b> Don't use bare repositories because the current implementation finds the <code>.git</code> directory in the repository's directory.

Launch
------

After all start the application:

    bundle exec rails server

<b>Note:</b> If you want to use it in production use the <code>RAILS_ENV=production</code> environment setting (you should migrate the database with this setting too)
