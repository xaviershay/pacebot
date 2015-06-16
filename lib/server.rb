require 'sinatra'
require 'json'
require 'pacebot'

bot = Pacebot.new

post '/' do
  input = params['text']
  text = if params['user_name'] != 'slackbot'
    resp = bot.parse(input)

    resp && bot.format(resp)
  end

  {
    text: text,
    input: input
  }.to_json
end

get '/' do
  erb :index
end
