class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show edit update destroy]

  def index
    highest_week = Article.maximum(:week)
    @articles = Article.where.not(article_type: 'gm')
    @articles_main = Article.where.not(article_type: 'gm').order(week: :desc).limit(6)
    @articles_other = Article.where.not(article_type: 'gm').order(week: :desc).offset(6)
    @articles_gm = Article.where(article_type: 'gm').where(week: highest_week).order(id: :desc)
  end

  def show
    @article = Article.find_by(id: params[:id])
  end

  def new
    @articles = Article.new

    @image_names = Dir.entries(Rails.root.join('app', 'assets', 'images')).select do |filename|
      filename =~ /\.(jpg|jpeg|png|gif|svg)$/i
    end
  end

  def edit; end

  def create
    @articles = Article.new(articles_params)

    respond_to do |format|
      if @articles.save
        format.html { redirect_to articles_url(@articles), notice: "Article was successfully created." }
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
        format.html { redirect_to articles_url(@articles), notice: "Article was successfully updated." }
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
      format.html { redirect_to articles_path, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_article
    @articles = Article.find(params[:id])
  end

  def articles_params
    params.require(:article).permit(:week, :club_id, :image, :article_type, :headline, :sub_headline, :article)
  end
end
