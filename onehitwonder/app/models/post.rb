class Post < ApplicationRecord
  belongs_to :feed
  attr_accessor :title, :url, :urlToImage, :description, :publishedAt, :author, :score, :subreddit, :numComments,
                :upvotes, :thumbnail, :commentsLink
  # has_many :TechCrunchPost
  # accepts_nested_attributes_for :TechCrunchPost
end
