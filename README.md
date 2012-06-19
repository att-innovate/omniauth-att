## To run this example locally

    bundle install
    ruby ./example_omniauth_app.rb
    open http://localhost:4567
    
## To deploy to heroku
    
   heroku create --stack cedar
   git push heorku master
   heroku config:add ATT_CLIENT_ID=asdfsdf ATT_CLIENT_SECRET=gggg  ATT_REDIRECT_URI=https://yourapp.heroku.com/auth/att/callback 
   heroku open
   
# config

base_domain = heroku info|grep Web|awk {'print $3'}

heroku config:add GIHUB_OAUTH_CLIENT_ID=b6ce639ebd5618ca4d52
heroku config:add GIHUB_OAUTH_CLIENT_SECRET=ef8b9abe468c2021d1e829f566091446375ea181

heroku config:add FACEBOOK_OAUTH_CLIENT_ID=290594154312564
heroku config:add FACEBOOK_OAUTH_CLIENT_SECRET=a26bcf9d7e254db82566f31c9d72c94e