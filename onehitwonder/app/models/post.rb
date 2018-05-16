class Post < ApplicationRecord
  belongs_to :feed
  attr_accessor :title, :url, :urlToImage, :description, :publishedAt
  # has_many :TechCrunchPost
  # accepts_nested_attributes_for :TechCrunchPost
end
