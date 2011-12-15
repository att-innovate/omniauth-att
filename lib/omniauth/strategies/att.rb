require 'multi_json'
require 'omniauth'
require 'omniauth/strategies/oauth2'
require 'active_support/core_ext/object'
require 'active_support/core_ext/hash'

module OmniAuth
  module Strategies
    class Att# < OmniAuth::Strategies::OAuth2
      include OmniAuth::Strategy

      args [:consumer_key, :consumer_secret]
      option :consumer_key, nil
      option :consumer_secret, nil
      option :redirect_uri, '/auth/att/callback'
      option :request_params, {}
      option :authorize_params, {}
      option :client_options, {}
      option :open_timeout, 30
      option :read_timeout, 30

      attr_reader :access_token
      
      option :client_options, {
        :site => ENV['ATT_BASE_DOMAIN'] || 'https://auth.tfoundry.com',
        :request_token_path => '/login',
        :port => 80
      }
      
      uid { raw_info['uid'] }
      
      info do
        prune!({
          'email' => raw_info['info']['email'],
          'name' => raw_info['info']['name']
        })
      end
      
      credentials do
        prune!({
          "token" => raw_info['uid']
        })
      end
      
      extra do
        prune!(raw_info)
      end
      
      def request_phase        
        # options.consumer_key, options.consumer_secret, options.client_options
        opts = {
          :client_id => options.consumer_key,
          :redirect_uri => request.url + '/callback'
        }
        redirect build_url('/auth/att', opts)
      end

      def callback_phase
        if raw_info
          super
        else
          [500, {"Content-Type" => "text/html"}, ["Problem authenticating"]]
        end
      end
      
      private
      
      def build_url(path, params={})
        uri           = URI.parse(site.to_s)
        
        uri.host    ||= site.host
        uri.port    ||= site.port
        uri.scheme  ||= site.scheme
        uri.path      = options.client_options.request_token_path

        params.update extra_params if options.extra_params
        uri.query = params.empty? ? nil : params.to_query

        uri.to_s
      end
      
      def prune!(hash)
        hash.delete_if do |_, value| 
          prune!(value) if value.is_a?(Hash)
          value.nil? || (value.respond_to?(:empty?) && value.empty?)
        end
      end
      
      
      def site
        @site ||= URI.parse(options.client_options.site)
      end
      
      def raw_info
        @raw_info ||= request.params
      end
      
    end
  end
end

OmniAuth.config.add_camelization 'att', 'Att'
