package com.avernet.signal.news;

import com.avernet.signal.config.GenericMapper;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface NewsMapper extends GenericMapper<News, NewsEntity> {
}
