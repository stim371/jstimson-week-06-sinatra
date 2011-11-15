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
    rescue
      halt 404, "Holy hell, something exploded."
    end


  end

  post // do
    halt 500, 'Whoa. Sorry. No POSTs allowed.'
  end

end