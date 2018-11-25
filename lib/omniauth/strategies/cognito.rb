require 'omniauth-oauth2'
require 'jwt'

module OmniAuth
  module Strategies
    # OmniAuth strategy based on omniauth-oauth2 to authenticate
    # with AWS Cognito. See https://github.com/omniauth/omniauth-oauth2.
    class Cognito < OmniAuth::Strategies::OAuth2
      option :name, 'cognito'
      option :client_options,
             auth_scheme: :basic_auth,
             authorize_url: '/oauth2/authorize',
             token_url: '/oauth2/token'
      option :info_fields, %i[email]
      option :jwt_leeway, 60

      uid do
        parsed_id_token && parsed_id_token['sub']
      end

      info do
        {}.tap do |result|
          if parsed_id_token
            options[:info_fields].each do |field|
              result[field] = parsed_id_token[field.to_s]
            end
          end
        end
      end

      credentials do
        {
          expires: access_token.expires?,
          expires_at: access_token.expires? && access_token.expires_at,
          id_token: id_token,
          refresh_token: access_token.expires? && access_token.refresh_token,
          token: access_token.token
        }.compact
      end

      extra do
        { raw_info: parsed_id_token }
      end

      private

      # See https://github.com/omniauth/omniauth-oauth2/issues/98 for redirect_uri reasoning
      def build_access_token
        client.auth_code.get_token(
          request.params['code'],
          { redirect_uri: callback_url }.merge(token_params.to_hash(symbolize_keys: true)),
          deep_symbolize(options.auth_token_params)
        )
      end

      # See https://github.com/omniauth/omniauth-oauth2/issues/93 - must remove query params
      def callback_url
        full_host + script_name + callback_path
      end

      def id_token
        access_token && access_token['id_token']
      end

      def parsed_id_token
        return nil unless id_token

        @parsed_id_token ||= JWT.decode(
          id_token,
          nil,
          false,
          verify_iss: options[:aws_region] && options[:user_pool_id],
          iss: "https://cognito-idp.#{options[:aws_region]}.amazonaws.com/#{options[:user_pool_id]}",
          verify_aud: true,
          aud: options[:client_id],
          verify_sub: true,
          verify_expiration: true,
          verify_not_before: true,
          verify_iat: true,
          verify_jti: false,
          leeway: options[:jwt_leeway]
        ).first
      end
    end
  end
end

OmniAuth.config.add_camelization 'cognito', 'Cognito'
