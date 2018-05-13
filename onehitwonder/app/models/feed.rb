class Feed < ApplicationRecord
  has_many :posts, dependent: :destroy

  @techcrunch_url = 'https://newsapi.org/v2/top-headlines?country=us&apiKey=523925afbae045e2a8aa3d9fdaef0b16'


  def getTechCrunchData
    client = HTTPClient.new
    client.get_content(@techcrunch_url)
  end


  def retrieve_techcrunch_results
    #JSON.parse(@getTechCrunchData)
    getTechCrunchData
  end

  # @techcrunch_url = 'https://newsapi.org/v2/top-headlines?country=us&apiKey=523925afbae045e2a8aa3d9fdaef0b16'
  #
  # def getTechCrunchPosts(id)
  #   client = HTTPClient.new
  #   api_response = client.get_content(@techcrunch_url)
  #   @techcrunch_json = api_response.parsed_response
  #   return @techcrunch_json
  # end

end