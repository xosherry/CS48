class UsatodayPost < Post
  # belongs_to :post

  def get_posts
    client = HTTPClient.new
    response = client.get_content('https://newsapi.org/v2/top-headlines?sources=usa-today&apiKey=cbf7161acff348ab83f3b8ace77abcbf')
    @usatoday_posts = JSON.parse(response)["articles"]

    list_of_usatoday_posts = []
    @usatoday_posts.each do |post|
      new_post = Post.new
      timeStamp = post['publishedAt']
      year = timeStamp[0...4].to_i
      month = timeStamp[5...7].to_i
      day = timeStamp[8...10].to_i
      hour = timeStamp[11...13].to_i
      minutes = timeStamp[14...16].to_i
      time = Time.new(year, month, day, hour, minutes);
      new_post.epochSeconds = time.to_i
      new_post.title = post["title"]
      new_post.url = post["url"]
      new_post.urlToImage = post["urlToImage"]
      new_post.description = post["description"]
      new_post.publishedAt = post["publishedAt"].to_s[0,10].split("-").reverse.join("-")
      new_post.source = "USATODAY"
      list_of_usatoday_posts << new_post
    end

    list_of_usatoday_posts
  end

end
