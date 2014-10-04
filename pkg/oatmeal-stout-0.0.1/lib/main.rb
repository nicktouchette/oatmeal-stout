# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'sinatra'

get '/' do
  'Hello World!'
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
  content_type :txt
  @defeat = {rock: :scissors, paper: :rock, scissors: :paper}
  @throws = @defeat.keys
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
  erb :index
end