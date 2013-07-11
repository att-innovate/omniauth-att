require 'net/http'
require "uri"
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'oauth2' 
require 'json'

set :logging, true

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

def client
  OAuth2::Client.new(
                     (ENV['ATT_CLIENT_ID']||'testing'),
                     (ENV['ATT_CLIENT_SECRET']||'testing'),
                     :site => ENV['ATT_AUTH_SERVER'],
                     :authorize_url => "#{ENV['ATT_AUTH_SERVER']}/oauth/authorize",
                     :token_url => "#{ENV['ATT_AUTH_SERVER']}/oauth/token"
                     )
end

def auth_url(scoped=ENV['ATT_SCOPE'])
  "#{ENV['ATT_AUTH_SERVER']}/oauth/authorize?client_id=#{ENV['ATT_CLIENT_ID']}&response_type=code&scope=#{scoped}"
  # client.auth_code.authorize_url(:response_type => "code", :scope => "IMMN")
end

get "/" do
  erb "<a class='btn btn-large' href='<%= auth_url %>'> <%= auth_url %> </a>"
end

get '/auth/att/callback' do
  puts request.inspect
  binding.pry
  access_token = client.auth_code.get_token(params[:code])
  # if request.env['rack.request.query_hash'][:code]
  #   @code = request.query_hash[:code]
  #   uri = URI.parse("#{ENV['ATT_AUTH_SERVER']}/oauth/token")
  
  #   response = Net::HTTP.post_form(uri, {:client_id=>ENV['ATT_CLIENT_ID'], :client_secret=>ENV['ATT_CLIENT_SECRET'], :grant_type=>'authorization_code', :code=>@code})
  #   erb response.body
  # else
  #   erb "<pre><%= response.inspect %></pre>" 
  # end
end

get '/auth/failure' do
  erb "<h1>Authentication Failed:</h1><h3>message:<h3> <pre>#{params}</pre>"
end

__END__
@@ layout

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>AT&T Developer Program - Test App</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
  </head>

  <body>
    <%= yield %>
  </body>
</html>
