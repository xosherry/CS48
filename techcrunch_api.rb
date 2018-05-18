# require 'open-uri'
# require 'json'

# url = 'https://newsapi.org/v2/top-headlines?'\
#       'country=us&'\
#       'apiKey=523925afbae045e2a8aa3d9fdaef0b16'
# req = open(url)
# response_body = req.read
# # puts response_body
# json_response = JSON.pretty_generate(JSON[response_body])
# puts json_response




# require 'HTTPClient'
# require 'json'

# url = 'https://newsapi.org/v2/top-headlines?'\
#   'country=us&'\
#   'apiKey=523925afbae045e2a8aa3d9fdaef0b16'

# client = HTTPClient.new
# response_body = client.get_content(url)
# pretty_json_response = JSON.pretty_generate(JSON[response_body])
# puts pretty_json_response

require 'HTTPClient'
require 'json'

client = HTTPClient.new
response = client.get_content('https://newsapi.org/v2/top-headlines?country=us&apiKey=523925afbae045e2a8aa3d9fdaef0b16')
results = JSON.parse(response)["articles"]

puts results
# results.each do |result|
# 	puts result["title"]
# end


