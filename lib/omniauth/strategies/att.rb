require 'multi_json'
require 'omniauth'

module OmniAuth
  module Strategies
    class Att
      include OmniAuth::Strategy
    end
  end
end

OmniAuth.config.add_camelization 'att', 'Att'
