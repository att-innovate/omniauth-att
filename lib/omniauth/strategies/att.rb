require 'multi_json'
require 'omniauth'

module OmniAuth
  module Strategies
    class Att
      include OmniAuth::Strategy
      
      
       include OmniAuth::Strategy

        args [:consumer_key, :consumer_secret]
        option :consumer_key, nil
        option :consumer_secret, nil
        option :redirect_uri

        attr_reader :access_token

        def request_phase
          redirect redirect_uri
        end

        def callback_phase
          puts env
          raise OmniAuth::NoSessionError.new("Session Expired") if session['att-auth'].nil?
          session['att-auth']=
          super
        end
        
      
    end
  end
end

OmniAuth.config.add_camelization 'att', 'Att'
