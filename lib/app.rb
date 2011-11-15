require 'sinatra'
require 'twitter'
require 'haml'

class TwitterInfo < Sinatra::Application

  set :views, settings.root + '/../views'

  get '/' do
    haml :index
  end

  get '/user/:username' do

    @user = params[:username]
    begin
      user_info = Twitter.user(@user)
      user_id = user_info.id
      @user_name = user_info.name
      @user_friend_count = user_info.friend_count
      followers = Twitter.follower_ids(user_id).ids
      @num_followers = followers.length
      
      haml :followers
    rescue Twitter::NotFound
      halt 404, "Way to go, buddy. There's no page for #{@user}"
    end
  end

  get '/mostrecent' do
    haml :mostrecentblank
  end

  get '/mostrecent/:username' do
    
    @user = params[:username]
    
    if @user
      @msg = Twitter.user_timeline(@user).first.text
      haml :mostrecent
    else
      haml :mostrecentblank
    end
  end

  post // do
    halt 500, 'Whoa. Sorry. No POSTs allowed.'
  end

end