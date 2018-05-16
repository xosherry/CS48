class TechCrunchPost < Post
  # belongs_to :post

  def get_posts
    client = HTTPClient.new
    response = client.get_content('https://newsapi.org/v2/top-headlines?country=us&apiKey=523925afbae045e2a8aa3d9fdaef0b16')
    @techcrunch_posts = JSON.parse(response)["articles"]

    list_of_techcrunch_posts = []
    @techcrunch_posts.each do |post|
      new_post = Post.new
      new_post.title = post["title"]
      new_post.url = post["url"]
      new_post.urlToImage = post["urlToImage"]
      new_post.description = post["description"]
      new_post.publishedAt = post["publishedAt"].to_s[0,10].split("-").reverse.join("-")
      list_of_techcrunch_posts << new_post
    end

    list_of_techcrunch_posts
  end

end
