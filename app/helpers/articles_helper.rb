module ArticlesHelper
    def order_by_popularity(articles)
        articles.sort_by{ |id, article| article[:being_read_by].count }.reverse
    end

    def order_by_date(articles)
        articles.sort_by{ | id, article| article["time_updated"] }.reverse
    end

    def randomize_articles(articles)
        articles = Hash[articles.to_a.shuffle]
    end
end
