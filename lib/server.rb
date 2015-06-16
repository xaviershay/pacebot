require 'sinatra'
require 'json'
require 'pacebot'

bot = Pacebot.new

post '/' do
  text = if params['user_name'] != 'slackbot'
    input = params['text']
    resp = bot.parse(input)

    resp && bot.format(resp)
  end

  {text: text}.to_json
end

get '/' do
  erb :index
end
