require 'open-uri'
require 'json'

url = 'https://newsapi.org/v2/top-headlines?'\
      'country=us&'\
      'apiKey=030ad3766b564dcab74d7d6752cfaac8'
req = open(url)
response_body = req.read
# puts response_body
json_response = JSON.pretty_generate(JSON[response_body])
puts json_response
