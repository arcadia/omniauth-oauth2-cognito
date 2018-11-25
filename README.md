# Omniauth Oauth2 Cognito

This Gem is an OAuth2 strategy for use with [Devise](https://github.com/plataformatec/devise) and [OmniAuth](https://github.com/omniauth/omniauth). It provides the ability to authenticate a user from an [AWS Cognito](https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-userpools-server-contract-reference.html) user pool and then sign the user into a rails application. It is based on the [omniauth-oauth2](https://github.com/omniauth/omniauth-oauth2) gem.

In order to use, follow the installation and usage guides below.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-oauth2-cognito', git: 'git@github.com:arcadia/omniauth-oauth2-cognito.git'
```

And then execute:

    $ bundle

## Usage

To configure this gem with Devise + Rails, follow the steps in this [guide](https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview). When you get to editing the `config/initializers/devise.rb` file, use the following configuration:

    Devise.setup do |config|
      ...

      config.omniauth :cognito,
        <cognito_client_id>,
        <cognito_client_secret>
        aws_region: <aws_region>
        callback_path: <!important - route used for cognito callback>,
        client_options: { site: <cognito_url> },
        scope: %i[openid email profile],
        user_pool_id: <cognito_user_pool_id>

      ...
    end

when configuring the user model, use the following devise setting:

    devise :omniauthable, omniauth_providers: %i[cognito]

and make sure the add a route in the routes.rb file that corresponds to the callback_path setting in the devise config above. So if you used `/auth/cognito/callback` for the callback route setting in cognito and in the devise config, then you would set a route like:

    devise_scope :users do
      get '/auth/cognito/callback', to: 'callbacks#cognito'
    end

The above route assumes you've set up your callbacks controller at `app/controllers/callbacks_controller.rb` like:

    class CallbacksController < Devise::OmniauthCallbacksController
      def cognito
        @user = User.from_omniauth(request.env['omniauth.auth'])

        # Do something with user on login if needed

        sign_in_and_redirect @user, event: :authentication
      end

      ...
    end

Make sure to complete all the steps in the [Devise + Omniauth guide](https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/omniauth-oauth2-cognito. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Omniauth::Oauth2::Cognito project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/omniauth-oauth2-cognito/blob/master/CODE_OF_CONDUCT.md).
