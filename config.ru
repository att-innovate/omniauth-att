$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.dirname(__FILE__)+"/lib")
require "rubygems"
require './example/example_omniauth_app.rb'

run SinatraApp