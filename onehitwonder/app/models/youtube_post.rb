class YoutubePost < Post
  # belongs_to :post

  def get_posts
    Yt.configure do |config|
      config.log_level = :debug
      config.api_key = 'AIzaSyDHGiq2sr0ip4yEDYQSH1MdxkQ7njkCJmo'
    end


    @youtube_posts = Yt::Collections::Videos.new.where(chart: 'mostPopular')
    list_of_youtube_posts = []
    @youtube_posts.each do |post|
      new_post = Post.new
      new_post.title = post.title
      new_post.url = "https://www.youtube.com/watch?v=" + post.id
      new_post.urlToImage = post.thumbnail_url
      new_post.description = post.description
      new_post.publishedAt = post.published_at.to_s[0,10].split("-").reverse.join("-")
      list_of_youtube_posts << new_post
    end

    list_of_youtube_posts
  end

end
