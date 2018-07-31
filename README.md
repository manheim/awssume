# Awssume

[![Circle CI](https://circleci.com/gh/manheim/awssume.svg?style=svg)](https://circleci.com/gh/manheim/awssume)

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

You can configure env vars to authenticate with AWS:

```
  $ export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
  $ export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
  $ export AWS_DEFAULT_REGION=us-west-2
```

If AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY aren't set then other
authentication options are checked (such as instance profiles).  This is
functionality provided by the aws-sdk.

```
  $ AWS_ROLE_ARN=arn::aws::iam::123456789012:role/RoletoAssume \
      awssume <command to execute>
```
```
  $ AWS_ROLE_ARN=arn::aws::iam::123456789012:role/RoletoAssume \
      awssume bundle exec rake component:deploy
```
```
  $ AWS_ROLE_ARN=arn::aws::iam::123456789012:role/RoletoAssume \
      awssume aws iam list-roles
```

There are scenarios where you might want to [use an external id][aws_ext_id]
in a condition on your assume role policy. For such cases, the gem will look
for the ``AWS_ROLE_EXTERNAL_ID`` variable in your environment. If this variable
is set the value will be sent along in the STS Assume Role request.

```
  $ AWS_ROLE_ARN=arn::aws::iam::123456789012:role/RoletoAssume \
    AWS_ROLE_EXTERNAL_ID=12345 \
      awssume aws iam list-roles
```

[aws_ext_id]: http://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-user_externalid.html

It's also possible to request credentials that
[last longer than the default of one hour](https://aws.amazon.com/about-aws/whats-new/2018/03/longer-role-sessions/)
if the role you're assuming is configured to support them (``MaxSessionDuration``
greater than 3600 seconds). Here's an example of assuming 12-hour (43200 second; the maximum)
credentials for a _really_ long-running command:

```
  $ AWS_ROLE_ARN=arn::aws::iam::123456789012:role/RoletoAssume \
    AWS_ROLE_DURATION_SECONDS=43200 \
      awssume really-long-running-command
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on
GitHub at https://github.com/Manheim/awssume.


## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
