package com.avernet.signal.news;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestClient;

import java.util.List;

@Service
public class NewsService {

    private final RestClient restClient;

    private final String apiKey;

    private final NewsRepository newsRepository;

    private final NewsMapper newsMapper;


    public NewsService(
            @Value("${newsdata-api-key}") String apiKey,
            @Value("${newsdata-base-url}") String baseUrl,
            NewsRepository newsRepository,
            NewsMapper newsMapper
    ) {
        this.restClient = RestClient.builder()
                .baseUrl(baseUrl)
                .build();

        this.apiKey = apiKey;
        this.newsRepository = newsRepository;
        this.newsMapper = newsMapper;
    }

    @Transactional
    public List<News> getLatestNews() {
        NewsDataResponse newsDataResponse = restClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/latest")
                        .queryParam("apikey", apiKey)
                        .queryParam("language", "fr")
                        .queryParam("country", "fr")
//                        .queryParam("image", 1)
                        .queryParam("prioritydomain", "top")
                        .build())
                .retrieve()
                .body(NewsDataResponse.class);
        
        if (newsDataResponse == null || newsDataResponse.results().isEmpty()) {
            return List.of();
        }

        List<News> newsList = newsDataResponse.results()
                .stream().map(this::toNews)
                .toList();

        List<NewsEntity> newsEntity = newsMapper.toEntityList(newsList);
        newsRepository.saveAll(newsEntity);

        return newsList;
    }

    private News toNews(NewsDataResult result) {
        return new News(
                null,
                result.article_id(),
                result.link(),
                result.title(),
                result.description(),
                result.image_url(),
                result.keywords(),
                result.category(),
                result.country(),
                result.pubDate(),
                result.source_name(),
                result.source_icon()
        );
    }
}
