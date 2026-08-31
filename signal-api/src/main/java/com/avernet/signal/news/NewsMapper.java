package com.avernet.signal.news;

import com.avernet.signal.config.GenericMapper;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface NewsMapper extends GenericMapper<News, NewsEntity> {
    default String map(NewsKeywordsEntity keywordsEntity) {
        return keywordsEntity.getKeyword();
    }

    default NewsKeywordsEntity map(String keyword) {
        NewsKeywordsEntity entity = new NewsKeywordsEntity();
        entity.setKeyword(keyword);
        return entity;
    }
}
