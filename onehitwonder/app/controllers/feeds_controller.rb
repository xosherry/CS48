class FeedsController < ApplicationController
  before_action :set_feed, only: [:show, :edit, :update, :destroy]
  # GET /feeds
  # GET /feeds.json

  def index
    @feeds = Feed.all

    # TECHCRUNCH

    client = HTTPClient.new
    response = client.get_content('https://newsapi.org/v2/top-headlines?country=us&apiKey=523925afbae045e2a8aa3d9fdaef0b16')
    @techcrunch_posts = JSON.parse(response)["articles"]

    #:title, :url, :urlToImage, :description, :publishedAt
    @list_of_techcrunch_posts = []
    @techcrunch_posts.each do |post|
      new_post = Post.new
      new_post.title = post["title"]
      new_post.url = post["url"]
      new_post.urlToImage = post["urlToImage"]
      new_post.description = post["description"]
      new_post.publishedAt = post["publishedAt"].to_s[0,10].split("-").reverse.join("-")
      @list_of_techcrunch_posts << new_post
    end

    # YOUTUBE

    Yt.configure do |config|
      config.log_level = :debug
      config.api_key = 'AIzaSyDHGiq2sr0ip4yEDYQSH1MdxkQ7njkCJmo'
    end


    @youtube_posts = Yt::Collections::Videos.new.where(chart: 'mostPopular')
    @list_of_youtube_posts = []
    @youtube_posts.each do |post|
      new_post = Post.new
      new_post.title = post.title
      new_post.url = "https://www.youtube.com/watch?v=" + post.id
      new_post.urlToImage = post.thumbnail_url
      new_post.description = post.description
      new_post.publishedAt = post.published_at.to_s[0,10].split("-").reverse.join("-")
      @list_of_youtube_posts << new_post
    end



  end

  # GET /feeds/1
  # GET /feeds/1.json
  def show

  end

  # GET /feeds/new
  def new
    @feed = Feed.new
  end

  # GET /feeds/1/edit
  def edit
  end

  # POST /feeds
  # POST /feeds.json
  def create
    @feed = Feed.new(feed_params)

    respond_to do |format|
      if @feed.save
        format.html { redirect_to @feed, notice: 'Feed was successfully created.' }
        format.json { render :show, status: :created, location: @feed }
      else
        format.html { render :new }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /feeds/1
  # PATCH/PUT /feeds/1.json
  def update
    respond_to do |format|
      if @feed.update(feed_params)
        format.html { redirect_to @feed, notice: 'Feed was successfully updated.' }
        format.json { render :show, status: :ok, location: @feed }
      else
        format.html { render :edit }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.json
  def destroy
    @feed.destroy
    respond_to do |format|
      format.html { redirect_to feeds_url, notice: 'Feed was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # # get techcrunch response
  # def retrieve_techcrunch_posts
  #   @techcrunch_posts = retrieve_techcrunch_results
  #
  # end

  def test
    client = HTTPClient.new
    response = client.get_content('https://newsapi.org/v2/top-headlines?country=us&apiKey=523925afbae045e2a8aa3d9fdaef0b16')
    @techcrunch_posts = JSON.parse(response)
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feed
      @feed = Feed.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feed_params
      params.require(:feed).permit(:name, :url, :description)
    end
end
