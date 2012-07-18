

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

<pre>
gem install bundler
</pre>


Initializing the app
--------------------

Install dependencies to .gems directory (without --path the gems will be stored in your <code>$HOME/.gems</code>)

<pre>
bundle install --path .gems
</pre>

(you may have to use <code>bundle update</code> before installing)

Create your database configuration in <code>config/database.yml</code> and migrate it. You can use the sample configuration file if you want to use sqlite3 database engine.

<pre>
cp config/database.yml.sample config/database.yml
bundle exec rake db:migrate
</pre>

Clone your repositories to <code>APP_DIR/repositories</code> directory (you can change its location in config/config.yml with repository_path variable).

<pre>
cd repositories
git clone https://github.com/Nucc/check.it.git
</pre>

<b>Important:</b> Don't use bare repositories because the current implementation finds the <code>.git</code> directory in the repository's directory.

Launch
------

Before launching, prepare your configuration file at <code>/config/config.yml</code>

<pre>
cp config/config.yml.sample config/config.yml
</pre>

After all start the application:

<pre>
bundle exec rails server
</pre>

<b>Note:</b> If you want to use it in production use the <code>RAILS_ENV=production</code> environment setting (you should migrate the database with this setting too)

Sending notification emails
---------------------------

You can send notification emails about unread review messages to developers. Just create a cronjob file and run <code>rake send_notifications</code> command every morning.

<b>Note:</b> Don't forget to set the site_url field in config/config.yml to email contains the url to your application!