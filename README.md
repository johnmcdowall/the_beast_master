# THE BEAST MASTER
The Beast Master is a simple system for recording what versions and when pieces of software are deployed to a given environment, and linking them back to Github. The Beast Master is eco-friendly, written minimally in Sinatra and uses the local file system to store its records so needs no database. The Beast Master is red. 

## INSTALATION
Make sure you have bundler installed. Then, at the command line:
    bundle 

You can try it out with the simple command (make sure to check out the configuration in the config directory FIRST):
    rackup

And then hitting the URL that rackup spins up, usually http://localhost:9292/

## TESTS
I welcome you to run them. Here's how:
    rspec

SimpleCov will run when you run the tests. Check the coverage report in the coverage directory/ 

## USAGE
The Beast Master responds to only two URLs:
* / (GET) - This loads the release dashboard
* /mark_release_for (POST) - This records a release for an environment and expects the following parameters as part of the POST:

    env      - the environment name, e.g. 'production', 'staging'
    project  - the project name, e.g. 'my_awesome_project'
    whom     - the name of the person deploying
    sha      - the SHA1 of the commit being deployed

No spaces are allowed in any of the parameters. 

Don't forget to pass along any credentials if you turn the auth on in the config. 

## CONFIGURATION
There's a sample config file in the config directory called the_beast_master_config.yml.sample. Current options are:
  release_db_path: The location in the file system where The Beast Master will store its records
  github_base_url: https://github.com/<you or your org>
  use_auth: false/true
  auth_username: admin or whatever
  auth_password: admin or whatever

## EXMAPLES
The idea is that you would call The Beast Master after a deploy has successfuly completed. If you want to fake it to test it out, use curl like so:

    curl -d "env=production&project=killer_project&sha=e8500d38bfeb296e080f728710445101cd54884f&whom=john" http://localhost:9292/mark_release

## CONTRIBUTING TO THE BEAST MASTER
I warmly welcome friendly pull requests.

* Check out the latest master to make sure the feature hasn’t been implemented or the bug hasn’t been fixed yet
* Check out the issue tracker to make sure someone already hasn’t requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don’t break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## LICENSE
Check out the accompany LICENSE file. It's the MIT License. 