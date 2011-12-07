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
   heroku addons:add newrelic
   heroku addons:add logging:expanded
