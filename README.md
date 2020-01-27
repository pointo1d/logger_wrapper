# LoggerWrapper

Class that attempts (from a newbie) to provision extension(s) to the core Ruby ```Logger``` class...
* Extending the _standard_ constants with...
  * ```ON``` - re-enable logging, restoring the level to the saved level.
  * ```OFF``` - disable logging, saving the current level.
  * ```CALLRET```, ```ENTRY``` & ```EXIT``` - defined for logging calls made at method entry/exit point(s) as appropriate.
  * ```TRACE``` - a level presenting an even more granular logging level.
* The ability to re-enable logging at the level before it was disabled (using the core ```off()``` method).

## Installation

A+dd this line to your application's Gemfile:

```ruby
gem 'logger_wrapper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install logger_wrapper

## Usage

```
require 'logger_wrapper'

class SomeClass
  def initialize
    @Logger = Logger.new
  end

  def some_method(*args)
    @Logger.entry(args)
    .
    .
    @Logger.exit
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/logger_wrapper.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## To Do
* Add extensible threshold level definition capability.
* Provision of shorthand logging method access i.e. without the need for an associated logger instance (reduce typing).
* Rework core extrension format from monkey patch to refined
* Use ```log4j```/```Log4Perl``` style configuration files with modifications...
  * As per Log4Perl, the ```::``` category separator is enabled (in addition to the 'normal' Java ```.``` separator).
  * The addition of default and associated env var override definitions.
  * Reducing typing by allowing nested definitions such that the following would be considered equivalent (they are actually normalised to the aforementioned separate line format)...
  ```
  A.B.C.D = 1.2.3
  A.B.C.E = val

   and 

  A:
    B:
      C:
        D: 1.2.3
        E: val
* Configurable self/internal logging - including the enabling and threshold level setting of internal start-up logging.
* Reworking of method names to more Ruby orientated e.g. ```threshold``` => ```set_threshold``` => ```threshold=```
* Using the default logger determined by the class hierarchy of the calling class.

