require 'httparty'
class RedditPost < Post
  # belongs_to :post

  def get_posts
    response = HTTParty.get("https://www.reddit.com/r/all.json", {
        headers: {"User-Agent" => "Httparty"}#,
        #debug_output: STDOUT, # To show that User-Agent is Httparty
    })
    html = response.body;
    json = JSON.parse(html)
    @reddit_posts = json['data']['children']

    #:title, :url, :urlToImage, :description, :publishedAt
    list_of_reddit_posts = []
    @reddit_posts.each do |post|
      new_post = Post.new
      new_post.url = post['data']['url']
      new_post.urlToImage = post['data']["urlToImage"]
      new_post.publishedAt = Time.at(post['data']['created_utc']).to_datetime
      new_post.numComments = post['data']['num_comments']
      new_post.commentsLink = "https://www.reddit.com" + post['data']['permalink']
      new_post.author = post['data']['author']
      new_post.score = post['data']['score']
      new_post.subreddit = post['data']['subreddit']
      new_post.upvotes = post['data']['ups']
      new_post.epochSeconds = post['data']['created_utc'].to_i
      timeSincePosted = Time.now.to_i - new_post.epochSeconds
      new_post.source = "REDDIT"
      thumbnail = "https://www.imforza.com/wp-content/uploads/2011/08/imforza-icon-link-building.png"
      if post['data'].key?('preview')
        thumbnail = post['data']['preview']['images'][0]['source']['url']
        if thumbnail.include? ".gif?"
          thumbnail = "https://www.imforza.com/wp-content/uploads/2011/08/imforza-icon-link-building.png"
        end
      end
      title = post['data']['title'];
      if title.length > 100
        title = title[0...100]
        title = title + "..."
      end

      new_post.thumbnail = thumbnail
      new_post.title = title
      #p new_post.title

      list_of_reddit_posts << new_post
    end
    list_of_reddit_posts
  end
end
