require 'twitter'
require 'net/http'
require 'uri'
class TwitterPost < Post
  # belongs_to :post

  def get_posts
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "l0OHILjs7kM4MKhDQb6nss3Bt"
      config.consumer_secret     = "air1vGE2BdnGpvByFRbb5vxIvzvucYUn2t6jAqwadBCFanps97"
      config.access_token        = "254971354-nxvJiNVFoCOi1LJqca8PhhAswJkohfL5IewPNNMr"
      config.access_token_secret = "FA2uhkKPqtsogqrQkMtvuCqnz0HNazjVa0HX4xDTL5qQY"
    end

    twitterJsonArray = [] #array of multiple json objects (per tweet)
    i = 0
    @client.trends(23424977).take(10).each do |trend|
      tweetHash = Hash.new
      tweetHash["title"] = trend.name
      strTrend = trend.name.to_s
      if strTrend.include? "#"
        strTrend = strTrend[1,strTrend.size]
        tweetHash["trendURL"] = "https://twitter.com/hashtag/" + strTrend + "?src=hash"
      elsif strTrend.include? " "
        strTrend = strTrend.gsub " ", "%20"
        tweetHash["trendURL"] = "https://twitter.com/search?q=%22" +  strTrend  + "%22&src=tren"
      else
        tweetHash["trendURL"] = "https://twitter.com/"
      end


      @client.search(trend.name, lang: "en", include_entities:"true", retweeted:"false", is_quote_status:"false").take(1).each do |tweet|
        tweetHash["author"] = tweet.user.name +  "       @" + tweet.user.screen_name
        tweetHash["publishedAt"] = tweet.created_at
        tweetHash["url"] = tweet.uri.to_s

        if tweet.retweet?
          tweetHash["description"] = tweet.retweeted_status.text.gsub /&amp;/, "&"
          tweetHash["publishedAt"] = tweet.retweeted_status.created_at
        elsif tweet.quoted_tweet?
          tweetHash["description"] = tweet.quoted_status.text.gsub /&amp;/, "&"
          tweetHash["publishedAt"] = tweet.quoted_status.created_at
        else
          tweetHash["description"] = tweet.text.gsub /&amp;/, "&"
        end

        str = "https://twitter.com/" + tweet.user.screen_name + "/profile_image?size=original"
        res = Net::HTTP.get_response(URI(str))
        tweetHash["urlToImage"] = res['location']


      end

      tweetToJson = tweetHash.to_json #turn single hash into json
      twitterJsonArray[i] = tweetToJson #add single json object to json array
      i = i + 1
    end

    twitterJson = twitterJsonArray.map{ |s| JSON[s] }.to_json
    @twitter_posts = JSON.parse(twitterJson)

    #:title, :url, :urlToImage, :description, :publishedAt
    list_of_twitter_posts = []

    @twitter_posts.each do |post|
      new_post = Post.new
      timeStamp = post['publishedAt']
      p post['title']
      p timeStamp
      year = timeStamp[0...4].to_i
      month = timeStamp[5...7].to_i
      day = timeStamp[8...10].to_i
      hour = timeStamp[11...13].to_i
      minutes = timeStamp[14...16].to_i

      p "#{year} - #{month} - #{day} #{hour}:#{minutes}"
      time = Time.new(year, month, day, hour, minutes, nil, "+00:00")
      new_post.epochSeconds = time.to_i
      p "EpochSeconds: #{new_post.epochSeconds}     Now: #{Time.now.to_i}"

      new_post.author = post["author"]
      new_post.title = post["title"]
      new_post.url = post["url"]
      new_post.urlToImage = post["urlToImage"]
      new_post.description = post["description"]
      new_post.publishedAt = ["publishedAt"]
      new_post.trendURL = post["trendURL"]
      new_post.source = "TWITTER"
      secondsSincePosted = Time.at(Time.now.to_i - new_post.epochSeconds).to_i
      p secondsSincePosted
      s = ""
      if secondsSincePosted < 3600
        if secondsSincePosted/60 > 1
          s = "s"
        end
          new_post.publishedAt = "Posted #{secondsSincePosted/60} minute#{s} ago."
          s = ""
        if secondsSincePosted/60 == 0
          new_post.publishedAt = "Posted now."
        end
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
      list_of_twitter_posts << new_post
    end

    list_of_twitter_posts
  end

end

# require 'twitter'
# require 'net/http'
# require 'uri'
# class TwitterPost < Post
#   # belongs_to :post
#
#   def get_posts
#     @client = Twitter::REST::Client.new do |config|
#       config.consumer_key        = "l0OHILjs7kM4MKhDQb6nss3Bt"
#       config.consumer_secret     = "air1vGE2BdnGpvByFRbb5vxIvzvucYUn2t6jAqwadBCFanps97"
#       config.access_token        = "254971354-nxvJiNVFoCOi1LJqca8PhhAswJkohfL5IewPNNMr"
#       config.access_token_secret = "FA2uhkKPqtsogqrQkMtvuCqnz0HNazjVa0HX4xDTL5qQY"
#     end
#
#     twitterJsonArray = [] #array of multiple json objects (per tweet)
#     i = 0
#     @client.trends(23424977).take(10).each do |trend|
#       tweetHash = Hash.new
#       tweetHash["title"] = trend.name
#
#       @client.search(trend.name, lang: "en", include_entities:"true", retweeted:"false", is_quote_status:"false").take(1).each do |tweet|
#         tweetHash["author"] = tweet.user.name +  "       @" + tweet.user.screen_name
#         tweetHash["publishedAt"] = tweet.created_at
#         tweetHash["url"] = tweet.uri.to_s
#
#         if tweet.retweet?
#               tweetHash["description"] = tweet.retweeted_status.text.gsub /&amp;/, "&"
#         elsif tweet.quoted_tweet?
#               tweetHash["description"] = tweet.quoted_status.text.gsub /&amp;/, "&"
#         else
#               tweetHash["description"] = tweet.text.gsub /&amp;/, "&"
#         end
#
#         str = "https://twitter.com/" + tweet.user.screen_name + "/profile_image?size=original"
#         res = Net::HTTP.get_response(URI(str))
#         tweetHash["urlToImage"] = res['location']
#
#
#       end
#
#       tweetToJson = tweetHash.to_json #turn single hash into json
#       twitterJsonArray[i] = tweetToJson #add single json object to json array
#       i = i + 1
#     end
#
#     twitterJson = twitterJsonArray.map{ |s| JSON[s] }.to_json
#     @twitter_posts = JSON.parse(twitterJson)
#
#     #:title, :url, :urlToImage, :description, :publishedAt
#     list_of_twitter_posts = []
#
#     @twitter_posts.each do |post|
#       new_post = Post.new
#       timeStamp = post['publishedAt']
#       year = timeStamp[0...4].to_i
#       month = timeStamp[5...7].to_i
#       day = timeStamp[8...10].to_i
#       hour = timeStamp[11...13].to_i
#       minutes = timeStamp[14...16].to_i
#       time = Time.new(year, month, day, hour, minutes)
#       new_post.epochSeconds = time.to_i
#       new_post.author = post["author"]
#       new_post.title = post["title"]
#       new_post.url = post["url"]
#       new_post.urlToImage = post["urlToImage"]
#       new_post.description = post["description"]
#       new_post.publishedAt = post["publishedAt"]
#       new_post.source = "TWITTER"
#       list_of_twitter_posts << new_post
#     end
#
#     list_of_twitter_posts
#   end
#
# end
