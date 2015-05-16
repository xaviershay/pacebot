require 'stringio'
require 'json'
require 'cgi'
require 'pp'

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

require 'pacebot'

bot = Pacebot.new
app = lambda do |env|
  request = Rack::Request.new(env)
  text = if request.params['user_name'] != 'slackbot'
    input = request.params['text']
    resp = bot.parse(input)

    resp && bot.format(resp)
  end

  body = {
    text: text
  }

  [200, {"Content-Type" => "application/json"}, StringIO.new(body.to_json)]
end

run app
