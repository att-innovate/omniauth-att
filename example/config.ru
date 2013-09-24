require 'rubygems'
require 'bundler'

Bundler.require

require './example_omniauth_app.rb'

puts "using  :site => #{ENV['ATT_BASE_DOMAIN']}"

run SinatraApp
