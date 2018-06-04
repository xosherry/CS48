class Post < ApplicationRecord
  include Comparable
  belongs_to :feed
  attr_accessor :title, :url, :urlToImage, :description, :publishedAt, :author, :score, :subreddit, :numComments,
                :upvotes, :thumbnail, :commentsLink, :epochSeconds, :source
  # has_many :TechCrunchPost
  # accepts_nested_attributes_for :TechCrunchPost
  def <=>(other)
    epochSeconds <=> other.epochSeconds
  end
end
