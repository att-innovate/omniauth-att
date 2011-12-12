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
        :request_token_path => '/auth/att',
        :port => 80
      }
      
      uid do
        raw_info['uid']
      end
      
      info do
        prune!({
          'uid' => raw_info['uid'],
          'email' => raw_info['info']['email'],
          'name' => raw_info['info']['name']
        })
      end

      extra do
        prune!({'raw_info' => raw_info})
      end
      
      def request_phase
        session['att-auth'] ||= {}
        session['att-auth'][name.to_s] = {}
        
        # options.consumer_key, options.consumer_secret, options.client_options
        opts = {
          :redirect_uri => 'http://localhost:9393/auth/att/callback'
        }
        redirect build_url('/auth/att', opts)
      end

      def callback_phase
        # raise OmniAuth::NoSessionError.new("Session Expired") if session['att-auth'].nil?
        super
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
