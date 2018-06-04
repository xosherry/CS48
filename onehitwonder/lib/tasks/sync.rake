namespace :sync do
  task feeds: [:environment] do
    Feed.all.each do |feed|
      content = Feedjira::Feed.fetch_and_parse feed.url
      content.posts.each do |post|
        local_post = feed.posts.where(title: post.title).first_or_initialize
        local_post.update_attributes(content: post.content, author: post.author, url: post.url, published: post.published)
        p "Synced Entry - #{post.title}"
      end
      p "Synced Feed - #{feed.name}"
    end
  end
end
