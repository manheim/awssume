# Awssume

Assume a role, do a thing.

This is a gem for assuming an AWS IAM role and using the returned temporary
credentials to do something such as run a deploy script or execute an aws cli
command. This gem was created because of the need to assume a role using
an instance profile on an EC2 instance and use the resulting credentials to
do some work.  This functionality doesn't currently exist in some often used
community tools.

References:
[AWS Cli Issue](https://github.com/aws/aws-cli/issues/1390)
[Terraform Issue](https://github.com/hashicorp/terraform/issues/1275)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'awssume'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install awssume

## Usage

This gem has the potential to be used as a library in a project using Ruby.
After a few things are implemented(such as a global configuration block) usage
instructions for using as a library will be added.

Currently the focus has been to use this gem as a command line tool.

```
  $ gem install awssume
  $ AWS_REGION=us-east-1 \
      AWS_ROLE_ARN=arn::aws::iam::123456789012:role/RoletoAssume \
      awssume <command to execute>
```
```
  $ gem install awssume
  $ AWS_REGION=us-east-1 \
      AWS_ROLE_ARN=arn::aws::iam::123456789012:role/RoletoAssume \
      awssume bundle exec rake component:deploy
```
```
  $ gem install awssume
  $ AWS_REGION=us-east-1 \
      AWS_ROLE_ARN=arn::aws::iam::123456789012:role/RoletoAssume \
      awssume aws iam list-roles
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Manheim/awssume.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
