require 'multi_json'
require 'omniauth'
require 'omniauth-oauth2'
require 'omniauth/strategies/oauth2'
require 'rest_client'
require 'active_support/core_ext/object'
require 'active_support/core_ext/hash'
require 'json'

module OmniAuth
  module Strategies
    class Att < OmniAuth::Strategies::OAuth2
      option :name, "att"

      option :client_options, {
        :site => ENV['ATT_BASE_DOMAIN'] || 'https://auth.tfoundry.com',
        :authorize_url => '/oauth/authorize',
        :token_url => '/oauth/token'
      }

      # These are called after authentication has succeeded. 
      uid{ raw_info['uid'] }

      info do
        prune!({
          :name => raw_info['info']['name'],
          :email => raw_info['info']['email']
        })
      end

      extra do
        {
          # 'raw_info' => prune!(raw_info)
        }
      end

      credentials do
        hash = {'token' => access_token.token}
        hash.merge!('refresh_token' => access_token.refresh_token) if access_token.expires?
        hash.merge!('expires_at' => access_token.expires_at) if access_token.expires?
        hash.merge!('expires' => access_token.expires?)
        hash
      end

      def full_host
        ENV['RACK_ENV'] == 'production' ? super.gsub('http:', 'https:') : super
      end

      def request_phase
        options[:scope] = 'profile'
        options[:authorize_params][:response_type] = 'client_credentials'
        super
      end

      def callback_phase
        super
      end

      def build_access_token
        a = super
        self.access_token = ::OAuth2::AccessToken.new(client, a.token, a.params)
      end

      def raw_info
        @raw_info ||= access_token.get('/me.json').parsed
      end

      private
      
      def prune!(hash)
        hash.delete_if do |_, value|
          prune!(value) if value.is_a?(Hash)
          value.nil? || (value.respond_to?(:empty?) && value.empty?)
        end
      end

    end
  end
end


OmniAuth.config.add_camelization 'att', 'Att'
