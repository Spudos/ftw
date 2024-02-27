class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy ]

  def index
    @articles = Article.all
    @articles_main = Article.order(week: :desc).limit(6)
    @articles_other = Article.order(week: :desc).offset(6)
  end

  def show
    @article = Article.find_by(id: params[:id])
  end

  def new
    @articles = Article.new
  end

  def edit
  end

  def create
    @articles = Article.new(articles_params)

    respond_to do |format|
      if @articles.save
        format.html { redirect_to articles_url(@articles), notice: "Articles was successfully created." }
        format.json { render :show, status: :created, location: @articles }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @articles.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @articles.update(articles_params)
        format.html { redirect_to articles_url(@articles), notice: "Articles was successfully updated." }
        format.json { render :show, status: :ok, location: @articles }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @articles.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @articles.destroy

    respond_to do |format|
      format.html { redirect_to articles_index_url, notice: "Articles was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_article
      @articles = Article.find(params[:id])
    end

    def articles_params
      params.require(:article).permit(:week, :club_id, :image, :articles_type, :headline, :sub_headline, :article)
    end
end
