package com.avernet.signal.news;

import com.avernet.signal.config.GenericMapper;
import com.avernet.signal.news.news_categories.NewsCategoriesEntity;
import com.avernet.signal.news.news_keywords.NewsKeywordsEntity;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface NewsMapper extends GenericMapper<News, NewsEntity> {
    default String mapKeyword(NewsKeywordsEntity keywordsEntity) {
        return keywordsEntity.getKeyword();
    }

    default NewsKeywordsEntity mapKeywordEntity(String keyword) {
        NewsKeywordsEntity entity = new NewsKeywordsEntity();
        entity.setKeyword(keyword);
        return entity;
    }
    
    default String mapCategory(NewsCategoriesEntity newsCategoriesEntity) {
        return newsCategoriesEntity.getCategory();
    }

    default NewsCategoriesEntity mapCategoryEntity(String category) {
        NewsCategoriesEntity entity = new NewsCategoriesEntity();
        entity.setCategory(category);
        return entity;
    }
}
