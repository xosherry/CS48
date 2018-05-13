class Post < ApplicationRecord
  belongs_to :feed
  attr_accessor :title, :url, :urlToImage, :description, :publishedAt
end
