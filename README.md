## To run this example locally

    bundle install
    ruby ./example_omniauth_app.rb
    open http://localhost:4567
    
## To deploy to heroku
    
   heroku create --stack cedar
   git push heorku master
   heroku open
   
### Add some goodies

   heroku addons:add releases
   heroku addons:upgrade releases:advanced
   heroku addons:add ssl:piggyback
   heroku addons:upgrade logging:expanded
   heroku addons:add loggly:mole
   heroku addons:add memcache:5mb
   heroku addons:add stillalive:basic

   heroku config:add RACK_ENV=production
   heroku addons:add newrelic  
   heroku addons:add redistogo:nano   
   
# config

base_domain = heroku info|grep Web|awk {'print $3'}

heroku config:add GIHUB_OAUTH_CLIENT_ID=b6ce639ebd5618ca4d52
heroku config:add GIHUB_OAUTH_CLIENT_SECRET=ef8b9abe468c2021d1e829f566091446375ea181

heroku config:add FACEBOOK_OAUTH_CLIENT_ID=290594154312564
heroku config:add FACEBOOK_OAUTH_CLIENT_SECRET=a26bcf9d7e254db82566f31c9d72c94e


heroku config:add FACEBOOK
