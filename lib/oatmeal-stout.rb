# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'sinatra'

configure do
  set :show_exceptions, false
  enable :sessions
end
get '/div_by_zero' do
  0 / 0
  "You won't see me."
end

error do
  "WTF!?"
end

get '/request' do
  @names = Array.new
  request.env.map.each do |e|
    @names << e.to_s
  end
  erb :sample
end

get '/cacheportal' do
  "<a href=/cached>Cached</a><br><a href=/uncached>Uncached</a>"
end

get '/cached' do
  headers "Cache-Control" => "public, must-revalidate, max-age=3600", 
    "Expires" => Time.at(Time.now.to_i + (60 * 60)).to_s
  "<p>This page rendered at #{Time.now}.<p><a href=/cacheportal>Back</a>"
end

get '/uncached' do
  "<p>This page rendered at #{Time.now}.<p><a href=/cacheportal>Back</a>"
end

before '/plain-text' do
  content_type :txt
end
get '/html' do
  '<h1>You should see HTML rendered.</h1>'
end
get '/plain-text' do
  '<h1>You should see plain text rendered.</h1>'
end

get '/' do
  redirect '/request'
end

get %r{/hello/([\w]+)} do
  "Hello, #{params[:captures].first}!"
end

set(:probability) { |value| condition { rand <= value } }

get '/win_a_car', :probability => 0.1 do
  "You won!"
end

get '/win_a_car' do
  "Sorry, you lost."
end

# before we process a route, we'll set the response as
# plain text and set up an array of viable moves that
# a player (and the computer) can perform
before do
  @defeat = {rock: :scissors, paper: :rock, scissors: :paper}
  @throws = @defeat.keys
end

not_found do
"Whoops! You requested a route that wasn't available."
end

get '/throw/:type' do
  # the params[] hash stores querystring and form data.
  player_throw = params[:type].to_sym
  # in the case of a player providing a throw that is not valid,
  # we halt with a status code of 403 (Forbidden) and let them
  # know they need to make a valid throw to play.
  if !@throws.include?(player_throw)
    halt 403, "You must throw one of the following: #{@throws}"
  end
  
  # now we can select a random throw for the computer
  computer_throw = @throws.sample
  # compare the player and computer throws to determine a winner
  if player_throw == computer_throw
    "You tied with the computer. Try again!"
  elsif computer_throw == @defeat[player_throw]
    "Nicely done; #{player_throw} beats #{computer_throw}!"
  else
    "Ouch; #{computer_throw} beats #{player_throw}. Better luck next time!"
  end
end

['/one/?', '/two/?', '/three'].each do |route|
  get route do
    "Triggered #{route} via GET"
  end
  post route do
    
    "Triggered #{route} via POST"
  end
  put route do
    "Triggered #{route} via PUT"
  end
  delete route do
    "Triggered #{route} via DELETE"
  end
  patch route do
    "Triggered #{route} via PATCH"
  end
end

#get '/public.html' do
#'This is delivered via the route.'
#end

get '/index' do
  @names = ['Chase', 'ruins', 'everything', 'and','is','becoming','a','Josue']
  erb :sample
end

get '/set' do
  session[:foo] = Time.now
  "Session value set."
end
get '/fetch' do
  "Session value: #{session[:foo]}"
end
get '/logout' do
  session.clear
  redirect '/fetch'
end