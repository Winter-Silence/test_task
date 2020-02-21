class NewsController < ApplicationController
  before_action :authenticate_user!, except: [:list_by_user, :index, :show]
  before_action :set_news, only: [:show, :update, :destroy]
  after_action :set_read, only: [:show]

  # GET /news
  def index
    @news = News.all

    render json: @news
  end

  # GET /news/1
  def show
    render json: @news
  end

  # POST /news
  def create
    @news = News.new(news_params)
    if @news.save
      render json: @news, status: :created, location: @news
    else
      render json: @news.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /news/1
  def update
    unless current_user.id == @news.user_id
      render json: 'forbidden access', status: :forbidden
    else
      if @news.update(news_params)
        render json: @news
      else
        render json: @news.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /news/1
  def destroy
    unless current_user.id == @news.user_id
      render json: 'forbidden access', status: :forbidden
    else
      @news.destroy
    end
  end

  def list_by_user
    render json: News.where(user_id: params[:user_id]).all
  end

  def add_to_favorites
    unless params[:news_id].nil?
      favorites = ListFavoriteNews.new(user_id: current_user.id, news_id: params[:news_id])
      if favorites.save
        render json: favorites
      else
        render json: favorites.errors, status: :unprocessable_entity
      end
    else
      render json: 'bad request', status: :bad_request
    end
  end

  def list_unreaded
    render json: News.left_outer_joins(:list_read_news).by_status(true).where('list_read_news.user_id = ?', current_user.id)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_news
    @news = News.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def news_params
    params.require(:news).permit!
  end

  def set_read
    if current_user and current_user.id != @news.user_id and not ListReadNews.by_user(current_user.id).by_news(@news.id).exists?
      read_news = ListReadNews.new(user_id: current_user.id, news_id: @news.id)
      read_news.save
    end
  end
end
