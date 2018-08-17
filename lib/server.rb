require 'sinatra'
require 'json'
require 'pacebot'

bot = Pacebot.new

post '/' do
  input = params['text']
  text = if params['user_name'] != 'slackbot'
    resp = bot.parse(input)

    if resp
      bot.format(resp)
    elsif params[:help_on_unknown]
      "examples: 5 mi, 4:00 mi, 3:10 kms, 3 mi @ 4:20, 3 mi in 12:50"
    end
  end

  {
    text: text,
    input: input
  }.to_json
end

get '/' do
  erb :index
end
