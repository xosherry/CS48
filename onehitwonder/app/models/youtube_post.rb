class YoutubePost < Post
  # belongs_to :post

  def get_posts
    Yt.configure do |config|
      config.log_level = :debug
      config.api_key = 'AIzaSyDHGiq2sr0ip4yEDYQSH1MdxkQ7njkCJmo'
    end


    @youtube_posts = Yt::Collections::Videos.new.where(chart: 'mostPopular').take(20)
    list_of_youtube_posts = []
    @youtube_posts.each do |post|
      new_post = Post.new
      new_post.source = "YOUTUBE"
      timeStamp = post.published_at.to_s
      year = timeStamp[0...4].to_i
      month = timeStamp[5...7].to_i
      day = timeStamp[8...10].to_i
      hour = timeStamp[11...13].to_i
      minutes = timeStamp[14...16].to_i
      time = Time.new(year, month, day, hour, minutes, nil, "+00:00")
      new_post.epochSeconds = time.to_i
      new_post.title = post.title
      new_post.url = "https://www.youtube.com/watch?v=" + post.id
      new_post.urlToImage = "https://img.youtube.com/vi/" + post.id + "/0.jpg"
      new_post.description = post.description
      if post.description.length > 80
        new_post.description = post.description[0...80] + "..."
      end
      new_post.publishedAt = post.published_at.to_s[0,10].split("-").reverse.join("-")
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
      list_of_youtube_posts << new_post
    end

    list_of_youtube_posts
  end

end
