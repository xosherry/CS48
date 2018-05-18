require 'twitter'
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
      @client.search(trend.name, lang: "en").take(1).each do |tweet|
        tweetHash["author"] = "@" + tweet.user.screen_name
        tweetHash["description"] = tweet.text.gsub /&amp;/, "&"
        tweetHash["publishedAt"] = tweet.created_at
        tweetHash["url"] = tweet.uri.to_s
        if tweet.media?
             tweetHash["urlToImage"] = tweet.media.collect(&:display_url).to_s[2..-3]
        else
             tweetHash["urlToImage"] = ""
        end
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
      new_post.title = post["title"]
      new_post.url = post["url"]
      new_post.urlToImage = post["urlToImage"]
      new_post.description = post["description"]
      new_post.publishedAt = post["publishedAt"]
      list_of_twitter_posts << new_post
    end

    list_of_twitter_posts
  end

end
