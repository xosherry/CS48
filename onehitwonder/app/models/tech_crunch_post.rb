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
      if new_post.description.to_s.length > 88
         new_post.description = post['description'][0...88] + "..."
      end
      new_post.publishedAt = post["publishedAt"].to_s[0,10].split("-").reverse.join("-")
      timeStamp = post['publishedAt']
      year = timeStamp[0...4].to_i
      month = timeStamp[5...7].to_i
      day = timeStamp[8...10].to_i
      hour = timeStamp[11...13].to_i
      minutes = timeStamp[14...16].to_i
      time = Time.new(year, month, day, hour, minutes, nil, "+00:00")
      new_post.epochSeconds = time.to_i
      new_post.source = "TECHCRUNCH"
      secondsSincePosted = (Time.at(Time.now.to_i - new_post.epochSeconds).to_i).abs
      s = ""
      if secondsSincePosted < 3600
        if secondsSincePosted/60 > 1
          s = "s"
        end
        new_post.publishedAt = "Posted #{secondsSincePosted/60} minute#{s} ago."
        s = ""
      elsif secondsSincePosted < 86400
        if secondsSincePosted/3600 > 1
          s = "s"
        end
        new_post.publishedAt = "Posted #{secondsSincePosted/3600} hour#{s}  ago."
        s = ""
      elsif secondsSincePosted < 604800
        if secondsSincePosted/86400 > 1
          s = "s"
        end
        new_post.publishedAt = "Posted #{secondsSincePosted/86400} day#{s} ago."
        s = ""
      elsif secondsSincePosted < 2592000
        if secondsSincePosted/604800 > 1
          s = "s"
        end
        new_post.publishedAt = "Posted #{secondsSincePosted/604800} week#{s} ago."
        s = ""
      elsif secondsSincePosted > 2592000
        if secondsSincePosted/2592000 > 1
          s = "s"
        end
        new_post.publishedAt = "Posted #{secondsSincePosted/2592000} month#{s} ago."
        s = ""
      end
      list_of_techcrunch_posts << new_post
    end

    list_of_techcrunch_posts
  end

end
