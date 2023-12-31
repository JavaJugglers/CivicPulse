# frozen_string_literal: true

class MyNewsItemsController < SessionController
  include MyNewsItemsControllerHelper

  before_action :set_issue_list
  before_action :set_representative
  before_action :set_representatives_list
  before_action :set_news_item, only: %i[edit update destroy]
  before_action :generate_news_item, only: %i[make]

  def new
    @news_item = NewsItem.new
  end

  def search
    @articles = NewsItem.get_articles(params[:representative_id], params[:issue])
  end

  def select
    @news_item = NewsItem.new
    @rep_id = @representative.id
    @rep_id = params[:rep_id] if params.has_key?('rep_id')
    @articles = NewsItem.get_articles(@rep_id, params[:issue])
    if @articles.empty?
      flash[:notice] = 'No articles found.'
      redirect_to representative_new_my_news_item_path(@representative)
      return
    end
    return unless @rep_id != @representative.id

    redirect_to representative_select_my_news_item_path({
                                                          representative_id: @rep_id,
                                                          issue:             params[:issue]
                                                        })
  end

  def make
    unless params.has_key? 'selected_article'
      redirect_to representative_select_my_news_item_path(
        { representative_id: @representative.id,
          issue:             params[:issue] }
      ), notice: 'No article selected'
      return
    end
    article = make_article
    redirect_to representative_news_item_path(@representative, article),
                notice: 'News item was successfully created.'
  end

  def make_article
    fields = NewsItem.get_articles(
      @representative.id,
      params[:issue]
    )[params[:selected_article].to_i]
    new_news_item = NewsItem.find_or_create_by!(
      title:             fields[:title],
      link:              fields[:link],
      description:       fields[:description],
      issue:             params[:issue],
      representative_id: @representative.id
    )
    new_news_item.ratings.create(score: params[:rating], user_id: session[:current_user_id])
    new_news_item.average_rating = Rating.get_average(new_news_item)
    new_news_item.save
    new_news_item
  end

  def edit; end

  #  def create
  #    @news_item = NewsItem.new(news_item_params)
  #    if @news_item.save
  #      redirect_to representative_news_item_path(@representative, @news_item),
  #                  notice: 'News item was successfully created.'
  #    else
  #      render :new, error: 'An error occurred when creating the news item.'
  #    end
  #  end

  def update
    if @news_item.update(news_item_params)
      redirect_to representative_news_item_path(@representative, @news_item),
                  notice: 'News item was successfully updated.'
    else
      render :edit, error: 'An error occurred when updating the news item.'
    end
  end

  def destroy
    if @news_item.nil?
      redirect_to representative_news_items_path({ representative_id: @representative.id })
      return
    end
    return unless @news_item.destroy

    redirect_to representative_news_items_path({ representative_id: @representative.id }),
                notice: 'News was successfully destroyed.'
    nil
  end

  private

  def set_representative
    @representative = Representative.find(
      params[:representative_id]
    )
  end

  def set_representatives_list
    @representatives_list = Representative.all.map { |r| [r.name, r.id] }
  end

  def set_issue_list
    @issue_list = NewsItem.issues.map { |i| [i, i] }
  end

  def generate_news_item
    @news_item = NewsItem.new
  end

  def set_news_item
    @news_item = nil
    @news_item = NewsItem.find(params[:id]) if NewsItem.exists?(id: params[:id])
  end

  # Only allow a list of trusted parameters through.
  def news_item_params
    params.require(:news_item).permit(:news, :title, :description, :link, :representative_id, :issue, :rating)
  end
end
